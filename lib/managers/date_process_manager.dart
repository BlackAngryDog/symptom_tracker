import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/enums/tracker_enums.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/database_objects/data_log.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/database_objects/track_option.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:collection/collection.dart';

class DataProcessManager {

  static Future<List<DataLog>> getLogs(DateTime start, DateTime end) async {
    return DataLog.collection(EventManager.selectedTarget.id!)
        .where('time', isGreaterThanOrEqualTo: start)
        .where('time', isLessThanOrEqualTo: end)
        .get(const GetOptions(source: Source.cache))
        .then((data) {
      List<DataLog> log = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return log;
    });
  }

  static Future<List<String>> getCurrValue(
      DateTime start, Tracker tracker, {int days = 7}) async {

      int i = 0;

      while (i < days) {
        var date = start.add(Duration(days: -i));
        var prevDate = start.add(Duration(days: -i + 1));

        var currValue = await tracker.getValue(day: date);
        var prevValue = await tracker.getValue(day: prevDate);

        i++;
      }
      return [];
  }

  static Future<List<LogTimeLineEntry>> getTrackersFor(
      DateTime start, DateTime end) async {

    var logs = List<LogTimeLineEntry>.empty(growable: true);

    for (var tracker in EventManager.selectedTarget.getTrackers())
    {

      var tgtDate = start.startOfDay;

      while (tgtDate.isBefore(end.endOfDay)) {
        var value = await tracker.getValue(day: tgtDate);
        // get last log with title
        var chartValue = double.tryParse(value) ?? 0.0;
        logs.add(LogTimeLineEntry(tgtDate, tracker.option.title ?? "",chartValue));
        tgtDate = tgtDate.add(const Duration(days: 1));
      }
    }
    return logs.sorted((a, b) { return a.date.compareTo(b.date);});
  }

  static Future<List<LogTimeLineEntry>> getTimeLine(
      DateTime start, DateTime end,
      {String optionID = ""}) async {
    List<TrackOption> options = (await TrackOption.getOptions())
        //.where((element) => element.trackType != dietTracker.option.trackType)
        .toList(growable: false);

    // Get all logs for target
    var logs = await EventManager.selectedTarget.getDataLogs(start, end);

    List<LogTimeLineEntry> timelineLogs = [];

    for (var log in logs) {
      var trackOption = options.where((e) => e.id == log.optionID).firstOrNull;
      var date = log.time;
      var title = trackOption?.title ?? "";
      var value = log.value;
      if (value is Map && value.entries.isNotEmpty) {
        List<String> combo = [];
        for (var entry in value.entries) {
          if (entry.value == true) combo.add(entry.key);
        }
        title = combo.join(",");
        if (combo.length > 1) {
          var last = combo.removeLast();
          title = "${combo.join(', ')} & $last";
        }
        value = 0;
      }

      timelineLogs.add(LogTimeLineEntry(
          date, title, double.tryParse(value.toString()) ?? 0.0));
    }

    return timelineLogs;
  }

  static Future<Map<String, Duration>> getDietFor(
      DateTime start, DateTime end,
      {String optionID = ""}) async {

    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getTracker(TrackerType.diet)!;

    List<DataLog> dietLogs =
    await dietTracker.getLogs(start.startOfDay, end.endOfDay);

    if (dietLogs.isEmpty) {
      DataLog? dietLog = await dietTracker.getLog(day: end.endOfDay);
      if (dietLog != null) {
        dietLogs.add(dietLog);
      } else {
        return {};
      }
    }

    var map = <String, Duration>{};

    // get start date and timespan between each log and the next.
    for (var i = 0; i < dietLogs.length; i++) {
      // get events within this timeframe tagged with this diet type
      var startSegment = dietLogs[i].time;
      var endSegment = dietLogs.length < i + 1
          ? dietLogs[i + 1].time
          : end.endOfDay;

      //get combined name for this segment
      List<String> combo = [];
      for (var entry in dietLogs[i].value!.entries) {
         combo.add(entry.value.toString());
      }
      var combined = combo.join(",");
      if (combo.length > 1) {
        var last = combo.removeLast();
        combined = "${combo.join(', ')} & $last";
      }

      var duration = endSegment.difference(startSegment);
      map.putIfAbsent(combined, () => const Duration());
      map[combined] = duration += map[combined]!;
    }

    return map;

  }



  static Future<Map<String, List<TimeLineEntry>>> getTimeLineByDiet(
      DateTime start, DateTime end,
      {String optionID = ""}) async {
    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getTracker(TrackerType.diet)!;

    List<DataLog> dietLogs =
        await dietTracker.getLogs(start.startOfDay, end.endOfDay);

    if (dietLogs.isEmpty) {
      DataLog? dietLog = await dietTracker.getLog(day: end.endOfDay);
      if (dietLog != null) {
        dietLogs.add(dietLog);
      } else {
        return {};
      }
    }

    var map = <String, List<TimeLineEntry>>{};

    // get start date and timespan between each log and the next.
    for (var i = 0; i < dietLogs.length; i++) {
      // get events within this timeframe tagged with this diet type
      var startSegment = dietLogs[i].time;
      var endSegment =
          dietLogs.length < i + 1 ? dietLogs[i + 1].time : end.endOfDay;

      //get combined name for this segment
      List<String> combo = [];
      for (var entry in dietLogs[i].value!.entries) {
        if (entry.value == true) combo.add(entry.key);
      }
      var combined = combo.join(",");
      if (combo.length > 1) {
        var last = combo.removeLast();
        combined = "${combo.join(', ')} & $last";
      }


      var logID = dietLogs[i].id.toString();
      map.putIfAbsent(logID, () => []);

      // get all other trackers.
      List<TrackOption> options = (await TrackOption.getOptions())
          .where((element) => element.trackType != dietTracker.option.trackType)
          .toList(growable: false);

      // Get all logs for target
      var logs = await EventManager.selectedTarget
          .getDataLogs(startSegment, endSegment);

      // for each TrackOption, get logs and compare to diet logs.
      for (var log in logs) {
        if (optionID.isNotEmpty && optionID == log.optionID) continue;

        // get TrackOption
        var trackOption =
            options.where((e) => e.id == log.optionID).firstOrNull;

        var value = double.tryParse(log.value.toString()) ?? 0;
        var key = trackOption?.title ?? "";
        if (key.isEmpty || value == 0) continue;

        try {
          var entry =
              map[logID]!.where((element) => element.option == key).firstOrNull;

          if (entry == null) {
            map[logID]!.add(TimeLineEntry(
                startSegment, endSegment, combined, key, [value]));
            continue;
          }
          entry.endDateTime = endSegment;
          entry.values.add(value);
        } on Exception catch (e) {
          // Anything else that is an exception
          print('Unknown exception: $e');
        } catch (e) {
          // No specified type, handles all
          print('Something really unknown: $e');
        }
      }
    }
    return map;
  }

  static Future<Map<String, Map<String, List<double>>>> getData(
      {String optionID = ""}) async {
    DateTime start = DateTimeExt.lastYear;

    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getTracker(TrackerType.diet)!;

    List<DataLog> dietLogs =
        await dietTracker.getLogs(start, DateTime.now().endOfDay);

    // get all other trackers.
    List<TrackOption> options = (await TrackOption.getOptions())
        .where((element) => element.trackType != dietTracker.option.trackType)
        .toList(growable: false);

    // Get all logs for target
    var logs = await EventManager.selectedTarget
        .getDataLogs(start, DateTime.now().endOfDay);

    var map = <String, Map<String, List<double>>>{};

    // for each TrackOption, get logs and compare to diet logs.
    for (var log in logs) {
      if (optionID.isNotEmpty && optionID == log.optionID) continue;

      // get diet value at this time.
      var diet = dietTracker.getValue(day: log.time);

      // get TrackOption
      var trackOption = options.where((e) => e.id == log.optionID).firstOrNull;

      var value = double.tryParse(log.value.toString()) ?? 0;
      var key = trackOption?.title ?? "";
      if (key.isEmpty || value == 0) continue;

      // what was the diet value at this time?
      DataLog? dietLog = await dietTracker.getLog(day: log.time);

      if (dietLog == null) continue;

      map.putIfAbsent(key, () => {});
      List<String> combo = [];
      for (var entry in dietLog.value!.entries) {
        if (entry.value == true) combo.add(entry.key);
      }

      try {
        var combined = combo.join(",");
        if (combo.length > 1) {
          var last = combo.removeLast();
          combined = "${combo.join(', ')} & $last";
        }
        map[key]!.putIfAbsent(combined, () => []);
        map[key]![combined]!.add(value);
      } on Exception catch (e) {
        // Anything else that is an exception
        print('Unknown exception: $e');
      } catch (e) {
        // No specified type, handles all
        print('Something really unknown: $e');
      }
    }

    return map;
  }

  static Future<Map<String, Map<String, List<double>>>> getDataOverTime(
      {
        DateTime? startTime,
        DateTime? endTime,
        String optionID = ""}
      ) async
  {
    DateTime start = startTime?.startOfDay ?? DateTimeExt.lastYear;
    DateTime end = endTime?.endOfDay ?? DateTime.now().endOfDay;

    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getTracker(TrackerType.diet)!;

    DateTime curr = start;
    var map = <String, Map<String, List<double>>>{};

    while (end.difference(curr).inDays > 0) {
      List<DataLog> dietLogs = await dietTracker.getLogs(curr, curr);

      // get all other trackers.
      List<TrackOption> options = (await TrackOption.getOptions())
          .where((element) => element.trackType != dietTracker.option.trackType)
          .toList(growable: false);

      // get diet for this day
      List<String> combo = [];
      DataLog? dietLog = await dietTracker.getLog(day: curr.endOfDay);
      for (var entry in dietLog?.value!.entries) {
        if (entry.value == true) combo.add(entry.key);
      }
      var combined = combo.join(",");
      if (combo.length > 1) {
        var last = combo.removeLast();
        combined = "${combo.join(', ')} & $last";
      }

      // get trackers and assign values
      for (var tracker in EventManager.selectedTarget.getTrackers()) {
        try {
          var combined = combo.join(",");
          if (combo.length > 1) {
            var last = combo.removeLast();
            combined = "${combo.join(', ')} & $last";
          }
          String title = tracker.option.title ?? "";
          map.putIfAbsent(title, () => {});
          map[title]!.putIfAbsent(combined, () => []);
          var v = await tracker.getValue(day: curr.endOfDay);
          var value = double.tryParse(v) ?? 0;
          map[title]![combined]!.add(value);
        } on Exception catch (e) {
          // Anything else that is an exception
          print('Unknown exception: $e');
        } catch (e) {
          // No specified type, handles all
          print('Something really unknown: $e');
        }
      }
      curr = curr.add(const Duration(days: 1));
    }
    return map;
  }

  static Future<List<DataLogSummary>> getSummary(
      {String diet = "", String option = ""}) async {
    var map = await getData(optionID: option);
    var datalogs = List<DataLogSummary>.empty(growable: true);
    var summary = <String, Map<String, DataLogSummary>>{};

    for (var dietMap in map.entries) {
      for (var entry in dietMap.value.entries) {
        var log = DataLogSummary(entry.key, dietMap.key, entry.value);
        if (diet.isNotEmpty && entry.key != diet) continue;
        if (option.isNotEmpty && dietMap.key != option) continue;

        datalogs.add(log);

        summary.putIfAbsent(dietMap.key, () => {});
        summary[dietMap.key]!.putIfAbsent(entry.key, () => log);
        print(
            'insight summary: ${dietMap.key} - ${entry.key} - ${entry.value.sum}');
      }
    }
    return datalogs;
  }

  static Future<List<DataLogSummary>> getSummaryOverTime(
      DateTime startTime, DateTime endTime,
      {String diet = "", String option = ""}) async {
    var map = await getDataOverTime(startTime: startTime, endTime: endTime);
    var dataLogs = List<DataLogSummary>.empty(growable: true);
    var summary = <String, Map<String, DataLogSummary>>{};

    for (var dietMap in map.entries) {
      for (var entry in dietMap.value.entries) {
        var log = DataLogSummary(entry.key, dietMap.key, entry.value);
        if (diet.isNotEmpty && entry.key != diet) continue;
        if (option.isNotEmpty && dietMap.key != option) continue;

        dataLogs.add(log);

        summary.putIfAbsent(dietMap.key, () => {});
        summary[dietMap.key]!.putIfAbsent(entry.key, () => log);
        print(
            'insight summary: ${dietMap.key} - ${entry.key} - ${entry.value.sum}');
      }
    }
    return dataLogs;
  }

  static getAverage({String diet = "", String option = ""}) async {
    var map = await getData();
    var average = <String, Map<String, double>>{};
    for (var dietMap in map.entries) {
      for (var entry in dietMap.value.entries) {
        var v = entry.value.average;
        if (diet.isNotEmpty && entry.key != diet) continue;
        if (option.isNotEmpty && dietMap.key != option) continue;
        average.putIfAbsent(dietMap.key, () => {});
        average[dietMap.key]!.putIfAbsent(entry.key, () => v);
        print(
            'insight average: ${dietMap.key} - ${entry.key} - ${entry.value.average}');
      }
    }
    return average;
  }

  static getMax({String diet = "", String option = ""}) async {
    var map = await getData();
    var max = <String, Map<String, double>>{};
    for (var dietMap in map.entries) {
      for (var entry in dietMap.value.entries) {
        var v = entry.value.max;
        if (diet.isNotEmpty && entry.key != diet) continue;
        if (option.isNotEmpty && dietMap.key != option) continue;
        max.putIfAbsent(dietMap.key, () => {});
        max[dietMap.key]!.putIfAbsent(entry.key, () => v);
        print(
            'insight max: ${dietMap.key} - ${entry.key} - ${entry.value.max}');
      }
    }
    return max;
  }

  static getMin({String diet = "", String option = ""}) async {
    var map = await getData();
    var min = <String, Map<String, double>>{};
    for (var dietMap in map.entries) {
      for (var entry in dietMap.value.entries) {
        var v = entry.value.min;
        if (diet.isNotEmpty && entry.key != diet) continue;
        if (option.isNotEmpty && dietMap.key != option) continue;
        min.putIfAbsent(dietMap.key, () => {});
        min[dietMap.key]!.putIfAbsent(entry.key, () => v);
        print(
            'insight min: ${dietMap.key} - ${entry.key} - ${entry.value.min}');
      }
    }
    return min;
  }
}

class DataLogSummary {
  final String diet;
  final String option;
  final List<double> values;

  final double min;
  final double max;
  final double average;
  final double total;

  DataLogSummary(this.diet, this.option, this.values)
      : min = values.min,
        max = values.max,
        average = (values.average * pow(10, 2)).round() / pow(10, 2),
        total = values.sum;
}

class TimeLineEntry {
  final String diet;
  final String option;
  final List<double> values;
  final DateTime startDateTime;
  DateTime endDateTime;

  double get min => values.isEmpty ? 0 : values.min;
  double get max => values.isEmpty ? 0 : values.max;
  double get average =>
      values.isEmpty ? 0 : (values.average * pow(10, 2)).round() / pow(10, 2);
  double get total => values.isEmpty ? 0 : values.sum;

  TimeLineEntry(this.startDateTime, this.endDateTime, this.diet, this.option,
      this.values);
}

class LogTimeLineEntry {
  final String title;
  final double value;
  final DateTime date;
  int count = 0;

  LogTimeLineEntry(this.date, this.title, this.value);
}


