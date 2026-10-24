import 'package:hairextensions/features/quotes/domain/entities/quote_status.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';
import 'package:hairextensions/shared/widgets/feedback/status_tone.dart';

extension QuoteStatusText on QuoteStatus {
  String label(AppLocalizations l10n) => switch (this) {
    QuoteStatus.quote => l10n.statusQuote,
    QuoteStatus.invoice => l10n.statusInvoice,
    QuoteStatus.paid => l10n.statusPaid,
  };

  StatusTone get tone => switch (this) {
    QuoteStatus.quote => StatusTone.primary,
    QuoteStatus.invoice => StatusTone.gold,
    QuoteStatus.paid => StatusTone.success,
  };
}
