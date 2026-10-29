import 'package:flutter/material.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/contracts/account_restorer.dart';
import 'package:hairextensions/core/network/client/api_client.dart';

/// Backend defaults that are not part of the short first-launch wizard.
class BusinessDefaultsPage extends StatefulWidget {
  const BusinessDefaultsPage({super.key});
  @override
  State<BusinessDefaultsPage> createState() => _BusinessDefaultsPageState();
}

class _BusinessDefaultsPageState extends State<BusinessDefaultsPage> {
  final _api = getIt<ApiClient>();
  final _form = GlobalKey<FormState>();
  final _fields = <String, TextEditingController>{};
  bool _loading = true;
  bool _saving = false;
  bool _wholePacks = true;
  String? _error;
  static const _labels = {
    'tax_label': 'Tax name (VAT / GST / Sales tax)',
    'tax_registration_number': 'Tax registration number',
    'hourly_rate': 'Default labour rate per hour',
    'default_markup_percent': 'Default hair markup (%)',
    'invoice_due_days': 'Invoice due in days',
    'invoice_terms': 'Invoice terms',
  };
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final response = await _api.get<Map<String, dynamic>>(
      '/v1/business',
      parser: (json) => json! as Map<String, dynamic>,
    );
    if (!mounted) return;
    if (!response.isSuccess || response.data == null) {
      setState(() {
        _loading = false;
        _error = 'Unable to load your business settings. Please retry.';
      });
      return;
    }
    final data = response.data!;
    for (final key in _labels.keys) {
      _fields.putIfAbsent(key, TextEditingController.new).text =
          '${data[key] ?? ''}';
    }
    setState(() {
      _wholePacks = data['whole_packs_default'] as bool? ?? true;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, Object?>{
      'whole_packs_default': _wholePacks,
      for (final key in _labels.keys) key: _fields[key]!.text.trim(),
    };
    body['invoice_due_days'] = int.parse(_fields['invoice_due_days']!.text);
    if (_fields['tax_registration_number']!.text.trim().isEmpty)
      body['tax_registration_number'] = null;
    final response = await _api.patch<void>(
      '/v1/business',
      body: body,
      parser: (_) {},
    );
    if (response.isSuccess) await getIt<AccountRestorer>().restore();
    if (!mounted) return;
    if (response.isSuccess) {
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error = 'Unable to save. Check your values and try again.';
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Business pricing & invoice settings')),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _fields.isEmpty
        ? Center(
            child: TextButton(onPressed: _load, child: Text(_error ?? 'Retry')),
          )
        : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Form(
                key: _form,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    for (final entry in _labels.entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _fields[entry.key],
                          enabled: !_saving,
                          decoration: InputDecoration(labelText: entry.value),
                          maxLines: entry.key == 'invoice_terms' ? 5 : 1,
                          maxLength: entry.key == 'invoice_terms'
                              ? 2000
                              : entry.key == 'tax_label'
                              ? 20
                              : null,
                          keyboardType:
                              [
                                'hourly_rate',
                                'default_markup_percent',
                                'invoice_due_days',
                              ].contains(entry.key)
                              ? const TextInputType.numberWithOptions(
                                  decimal: true,
                                )
                              : TextInputType.text,
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (entry.key == 'tax_label' && text.isEmpty)
                              return 'Required';
                            if ([
                              'hourly_rate',
                              'default_markup_percent',
                              'invoice_due_days',
                            ].contains(entry.key)) {
                              final n = double.tryParse(text);
                              if (n == null || !n.isFinite || n < 0)
                                return 'Enter a valid non-negative number';
                              if (entry.key == 'invoice_due_days' &&
                                  (n > 365 || int.tryParse(text) == null))
                                return 'Enter whole days from 0 to 365';
                              if (entry.key == 'default_markup_percent' &&
                                  n > 1000)
                                return 'Maximum 1000%';
                            }
                            return null;
                          },
                        ),
                      ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Charge whole hair packs by default'),
                      value: _wholePacks,
                      onChanged: _saving
                          ? null
                          : (value) => setState(() => _wholePacks = value),
                    ),
                    if (_error != null) Text(_error!),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: Text(_saving ? 'Saving…' : 'Save settings'),
                    ),
                  ],
                ),
              ),
            ),
          ),
  );
}
