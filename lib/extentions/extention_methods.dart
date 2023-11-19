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

  bool isSameDate(DateTime other) {
    return year == other.year &&
        month == other.month &&
        day == other.day;
  }

  String dayOfWeek(){
    // list of string representing days if the week
    List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday];
  }
}
/*
extension DateHelper on DateTime {

  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}
*/

