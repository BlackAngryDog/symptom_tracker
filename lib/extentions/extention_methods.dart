
import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day)
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  static DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime get lastYear {
    final now = DateTime.now();
    return DateTime(now.year - 1, now.month, now.day);
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
    return year == other.year && month == other.month && day == other.day;
  }

  String dayOfWeek() {
    // list of string representing days if the week
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday];
  }

  static String formatDate(DateTime date) {
    // TODO - Add format controls
    var dayFormat = DateFormat('d').format(date);
    var daySuffix = getDaySuffix(int.parse(dayFormat));
    return '${DateFormat('EEEE').format(date)} $dayFormat$daySuffix';
  }

  static String getDaySuffix(int day) {
    if (!(day >= 1 && day <= 31)) {
      throw ArgumentError('Invalid day of month');
    }

    if (day >= 11 && day <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

}


extension ParseToString on Enum {
  String toShortString() {
    return toString().split('.').last;
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
