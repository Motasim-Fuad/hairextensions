part of 'force_update_page.dart';

class _ForceUpdatePageState extends State<ForceUpdatePage> {
  bool _opening = false;
  bool _failed = false;

  Future<void> _openStore() async {
    setState(() {
      _opening = true;
      _failed = false;
    });
    final opened = await widget.launcher.open(widget.gate.config.storeUrl);
    if (!mounted) {
      return;
    }
    setState(() {
      _opening = false;
      _failed = !opened;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: EmptyState(
                icon: AppIcon.download,
                title: l10n.forceUpdateTitle,
                message: l10n.forceUpdateMessage,
              ),
            ),
            BottomActionBar(
              child: AppPrimaryButton(
                label: l10n.actionUpdateNow,
                leadingIcon: AppIcon.link,
                isLoading: _opening,
                errorText: _failed ? l10n.errorOpenStore : null,
                onPressed: _openStore,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
