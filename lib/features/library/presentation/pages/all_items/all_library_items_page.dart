import 'package:flutter/material.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/network/client/api_client.dart';

/// Full library editor: hair, labour, service, material and fee records.
class AllLibraryItemsPage extends StatefulWidget {
  const AllLibraryItemsPage({super.key});
  @override
  State<AllLibraryItemsPage> createState() => _AllLibraryItemsPageState();
}

class _AllLibraryItemsPageState extends State<AllLibraryItemsPage> {
  final _api = getIt<ApiClient>();
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted)
      setState(() {
        _loading = true;
        _error = null;
      });
    final all = <Map<String, dynamic>>[];
    var offset = 0;
    while (true) {
      final response = await _api.get<Map<String, dynamic>>(
        '/v1/library',
        query: {'limit': 100, 'offset': offset},
        parser: (json) => json! as Map<String, dynamic>,
      );
      if (!mounted) return;
      if (!response.isSuccess || response.data == null) {
        setState(() {
          _loading = false;
          _error = 'Unable to load your library. Please retry.';
        });
        return;
      }
      final page = response.data!;
      final items = (page['items'] as List).cast<Map<String, dynamic>>();
      all.addAll(items);
      offset += items.length;
      if (items.isEmpty || offset >= (page['total'] as num).toInt()) break;
    }
    if (mounted)
      setState(() {
        _items = all;
        _loading = false;
      });
  }

  Future<void> _edit([Map<String, dynamic>? item]) async {
    if (item != null) {
      final response = await _api.get<Map<String, dynamic>>(
        '/v1/library/${item['id']}',
        parser: (json) => json! as Map<String, dynamic>,
      );
      if (!mounted) return;
      if (!response.isSuccess) {
        _show('Unable to load this item. Please retry.');
        return;
      }
      item = response.data;
    }
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => _LibraryEditor(item: item)));
    if (mounted) await _load();
  }

  void _show(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Future<void> _delete(Map<String, dynamic> item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete library item?'),
        content: Text('${item['name']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final response = await _api.delete<void>(
      '/v1/library/${item['id']}',
      parser: (_) {},
    );
    if (!mounted) return;
    if (response.isSuccess || response.isNotFound) {
      await _load();
    } else {
      _show('Unable to delete this item. Please retry.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('All library items'),
      actions: [
        IconButton(
          tooltip: 'Add item',
          onPressed: () => _edit(),
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!, textAlign: TextAlign.center),
                TextButton(onPressed: _load, child: const Text('Retry')),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (_items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Add hair, labour, services, materials and fees.',
                    ),
                  ),
                for (final item in _items)
                  Card(
                    child: ListTile(
                      title: Text(
                        '${item['name']}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('${item['kind']}'),
                      onTap: () => _edit(item),
                      trailing: IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _delete(item),
                      ),
                    ),
                  ),
              ],
            ),
          ),
  );
}

class _LibraryEditor extends StatefulWidget {
  const _LibraryEditor({this.item});
  final Map<String, dynamic>? item;
  @override
  State<_LibraryEditor> createState() => _LibraryEditorState();
}

class _LibraryEditorState extends State<_LibraryEditor> {
  final _form = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  late String _kind = widget.item?['kind'] as String? ?? 'hair';
  late bool _taxable = widget.item?['taxable'] as bool? ?? true;
  bool _saving = false;
  String? _error;
  static const _limits = {
    'name': 120,
    'description': 500,
    'category': 60,
    'unit_label': 20,
  };
  List<String> get _fields => [
    'name',
    'description',
    'category',
    if (_kind == 'hair') ...[
      'grams_per_pack',
      'pack_price',
      'markup_percent',
    ] else if (_kind == 'labour')
      'hourly_rate'
    else ...[
      'unit_price',
      'unit_cost',
      'unit_label',
    ],
  ];
  TextEditingController _controller(String key) => _controllers.putIfAbsent(
    key,
    () => TextEditingController(text: '${widget.item?[key] ?? ''}'),
  );
  @override
  void dispose() {
    for (final value in _controllers.values) {
      value.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, Object?>{
      'kind': _kind,
      'taxable': _taxable,
      for (final key in _fields)
        key: _controller(key).text.trim().isEmpty
            ? null
            : _controller(key).text.trim(),
    };
    final api = getIt<ApiClient>();
    final response = widget.item == null
        ? await api.post<Object?>(
            '/v1/library',
            body: body,
            parser: (json) => json,
          )
        : await api.patch<Object?>(
            '/v1/library/${widget.item!['id']}',
            body: body,
            parser: (json) => json,
          );
    if (!mounted) return;
    if (response.isSuccess) {
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error = 'Unable to save. Check the values and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.item == null ? 'Add library item' : 'Edit library item',
      ),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              DropdownButtonFormField<String>(
                initialValue: _kind,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Item type'),
                items: [
                  for (final kind in [
                    'hair',
                    'labour',
                    'service',
                    'material',
                    'fee',
                  ])
                    DropdownMenuItem(value: kind, child: Text(kind)),
                ],
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _kind = value!),
              ),
              for (final key in _fields)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: _controller(key),
                    enabled: !_saving,
                    maxLength: _limits[key],
                    decoration: InputDecoration(
                      labelText: key.replaceAll('_', ' '),
                    ),
                    keyboardType: _limits.containsKey(key)
                        ? TextInputType.text
                        : const TextInputType.numberWithOptions(decimal: true),
                    validator: (text) {
                      final value = text?.trim() ?? '';
                      final required =
                          key == 'name' ||
                          (_kind == 'hair' &&
                              ['grams_per_pack', 'pack_price'].contains(key)) ||
                          (!['hair', 'labour'].contains(_kind) &&
                              key == 'unit_price');
                      if (required && value.isEmpty) return 'Required';
                      if (!_limits.containsKey(key) && value.isNotEmpty) {
                        final number = double.tryParse(value);
                        if (number == null ||
                            !number.isFinite ||
                            number < 0 ||
                            (key == 'grams_per_pack' && number == 0))
                          return 'Enter a valid positive amount';
                        if (key == 'markup_percent' && number > 1000)
                          return 'Maximum 1000';
                      }
                      return null;
                    },
                  ),
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Taxable'),
                value: _taxable,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _taxable = value),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(_error!),
                ),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving…' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
