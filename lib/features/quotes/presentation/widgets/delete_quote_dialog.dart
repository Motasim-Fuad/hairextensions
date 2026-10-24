import 'package:flutter/widgets.dart';
import 'package:hairextensions/core/extensions/l10n_context_extension.dart';
import 'package:hairextensions/core/theme/app_icon.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/shared/widgets/layout/app_confirm_dialog.dart';

/// Design 5.4.
abstract final class DeleteQuoteDialog {
  static Future<bool> show(BuildContext context, Quote quote) {
    final l10n = context.l10n;
    return AppConfirmDialog.show(
      context,
      icon: AppIcon.trash,
      title: l10n.deleteQuoteTitle,
      message: l10n.deleteQuoteMessage(quote.number, quote.clientName),
      confirmLabel: l10n.actionDelete,
      cancelLabel: l10n.actionCancel,
    );
  }
}
