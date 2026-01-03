import 'package:intl/intl.dart';

class DateTimeHelper {
  DateTimeHelper._();

  /// 🔹 Internal parser (SAFE for ISO strings)
  static DateTime _parse(String value) {
    return DateTime.parse(value);
  }

  /// ───────── DATE FORMATS ─────────

  /// 2 January 2026
  static String formatDate(String value) {
    return DateFormat('d MMMM yyyy').format(_parse(value));
  }

  /// Friday
  static String formatDay(String value) {
    return DateFormat('EEEE').format(_parse(value));
  }

  /// 2 Jan
  static String formatShortDate(String value) {
    return DateFormat('d MMM').format(_parse(value));
  }

  /// ───────── TIME FORMATS ─────────

  /// 2:00 PM  ← (2026-01-02T14:00)
  static String formatTime(String value) {
    return DateFormat.jm().format(_parse(value));
  }

  /// 2 PM
  static String formatHour(String value) {
    return DateFormat('h a').format(_parse(value));
  }

  /// ───────── DATE + TIME ─────────

  /// 2 Jan 2026 • 2:00 PM
  static String formatDateTime(String value) {
    return DateFormat('d MMM yyyy • h:mm a').format(_parse(value));
  }

  /// ───────── LOGIC HELPERS ─────────

  /// Is this datetime = NOW hour?
  static bool isNow(String value) {
    final now = DateTime.now();
    final t = _parse(value);

    return t.year == now.year &&
        t.month == now.month &&
        t.day == now.day &&
        t.hour == now.hour;
  }

  /// Is this datetime = TODAY?
  static bool isToday(String value) {
    final now = DateTime.now();
    final t = _parse(value);

    return t.year == now.year && t.month == now.month && t.day == now.day;
  }
}
