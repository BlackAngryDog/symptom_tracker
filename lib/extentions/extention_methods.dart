extension DateTimeExt on DateTime {
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day).add(const Duration(hours: 23, minutes: 59, seconds: 59));
  }

  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime get lastMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month - 1, now.day);
  }

  static DateTime get lastWeek {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - 7);
  }
}
