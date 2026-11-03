import 'package:intl/intl.dart';

/// Date helpers shared by reports, invoices and payroll. Dates are stored as
/// local wall-clock values; only `DateTime.now()` is used for "today".
class AppDate {
  const AppDate._();

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime endOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day, 23, 59, 59, 999);

  static DateTime startOfMonth(DateTime value) =>
      DateTime(value.year, value.month, 1);

  static DateTime endOfMonth(DateTime value) =>
      DateTime(value.year, value.month + 1, 0, 23, 59, 59, 999);

  static DateTime startOfYear(DateTime value) => DateTime(value.year, 1, 1);

  static DateTime addMonths(DateTime value, int months) =>
      DateTime(value.year, value.month + months, value.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static final DateFormat _display = DateFormat('dd/MM/yyyy');
  static final DateFormat _displayLong = DateFormat('dd MMM yyyy');
  static final DateFormat _monthLabel = DateFormat('MMM yyyy');
  static final DateFormat _isoDate = DateFormat('yyyy-MM-dd');
  static final DateFormat _time = DateFormat('hh:mm a');

  static String display(DateTime value) => _display.format(value);
  static String displayLong(DateTime value) => _displayLong.format(value);
  static String monthLabel(DateTime value) => _monthLabel.format(value);
  static String isoDate(DateTime value) => _isoDate.format(value);
  static String time(DateTime value) => _time.format(value);

  static DateTime? tryParseIsoDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// Financial year label for invoice numbering, e.g. 2026-27.
  static String financialYear(DateTime date) {
    final start = date.month >= 4 ? date.year : date.year - 1;
    final end = (start + 1) % 100;
    return '$start-${end.toString().padLeft(2, '0')}';
  }
}
