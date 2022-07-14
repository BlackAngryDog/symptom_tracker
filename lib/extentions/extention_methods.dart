extension DateTimeExt on DateTime {
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
