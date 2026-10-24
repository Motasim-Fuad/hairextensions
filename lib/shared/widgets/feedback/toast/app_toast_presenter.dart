import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/theme/tokens/app_motion.dart';
import 'package:hairextensions/shared/widgets/feedback/status_tone.dart';
import 'package:hairextensions/shared/widgets/feedback/toast/app_toast.dart';
import 'package:hairextensions/shared/widgets/feedback/toast/app_toast_overlay.dart';

/// Manual-only toast API. Nothing in the app calls this automatically.
abstract final class AppToastPresenter {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String message,
    StatusTone tone = StatusTone.neutral,
    String? actionLabel,
    VoidCallback? onAction,
    Duration visibleFor = AppMotion.toastVisible,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }
    dismiss();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => AppToastOverlay(
        visibleFor: visibleFor,
        onDismissed: () {
          if (identical(_current, entry)) {
            dismiss();
          }
        },
        child: AppToast(
          message: message,
          tone: tone,
          actionLabel: actionLabel,
          onAction: onAction == null
              ? null
              : () {
                  dismiss();
                  onAction();
                },
        ),
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }

  static void dismiss() {
    _current?.remove();
    _current = null;
  }
}
