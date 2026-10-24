import 'package:hairextensions/core/utils/date_formatter.dart';
import 'package:hairextensions/l10n/gen/app_localizations.dart';

/// "Today", "Yesterday", otherwise "8 Oct".
extension RelativeDayText on DateTime {
  String relativeDay(AppLocalizations l10n, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(DateTime(year, month, day)).inDays;
    if (difference == 0) {
      return l10n.dayToday;
    }
    if (difference == 1) {
      return l10n.dayYesterday;
    }
    return DateFormatter.dayMonth(this);
  }
}
