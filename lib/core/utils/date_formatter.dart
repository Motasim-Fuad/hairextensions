import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static final DateFormat _dayMonthYear = DateFormat('d MMM yyyy');
  static final DateFormat _dayMonth = DateFormat('d MMM');
  static final DateFormat _monthName = DateFormat('MMMM');
  static final DateFormat _monthShort = DateFormat('MMM');
  static final DateFormat _time = DateFormat('h:mm a');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');
  static final DateFormat _dateTime = DateFormat('d MMM yyyy, h:mm a');

  static String dayMonthYear(DateTime value) => _dayMonthYear.format(value);

  static String dayMonth(DateTime value) => _dayMonth.format(value);

  static String monthName(DateTime value) => _monthName.format(value);

  static String monthShort(DateTime value) => _monthShort.format(value);

  static String time(DateTime value) => _time.format(value);

  static String monthYear(DateTime value) => _monthYear.format(value);

  static String dateTime(DateTime value) => _dateTime.format(value);
}
