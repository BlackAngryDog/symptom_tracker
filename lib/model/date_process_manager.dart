import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:collection/collection.dart';

class DataProcessManager {
  static Future<List<DataLog>> getLogs(DateTime start, DateTime end) async {
    return DataLog.getCollection(EventManager.selectedTarget.id ?? 'default')
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

  static Future<Map<String, List<TimeLineEntry>>> getTimeLine(
      DateTime start, DateTime end,
      {String optionID = ""}) async {
    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getDietTracker();

    List<DataLog> dietLogs =
        await dietTracker.getLogs(start.startOfDay, end.endOfDay);

    var map = <String, List<TimeLineEntry>>{};

    // get start date and timespan between each log and the next.
    for (var i = 0; i < dietLogs.length - 1; i++) {
      // get events within this timeframe tagged with this diet type
      var startSegment = dietLogs[i].time;
      var endSegment = dietLogs[i + 1].time;

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

      map.putIfAbsent(combined, () => []);

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
          var entry = map[combined]!
                  .where((element) => element.option == key)
                  .firstOrNull ??
              TimeLineEntry(startSegment, endSegment, combined, key, []);

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
    Tracker dietTracker = EventManager.selectedTarget.getDietTracker();

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

      // if diet is null, skip.
      if (diet == null) continue;

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
      {DateTime? startTime, DateTime? endTime, String optionID = ""}) async {
    DateTime start = startTime?.startOfDay ?? DateTimeExt.lastYear;
    DateTime end = endTime?.endOfDay ?? DateTime.now().endOfDay;

    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getDietTracker();

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
      for (var tracker in EventManager.selectedTarget.trackers) {
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
      curr = curr.add(Duration(days: 1));
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
  final DateTime endDateTime;

  final double min;
  final double max;
  final double average;
  final double total;

  TimeLineEntry(
      this.startDateTime, this.endDateTime, this.diet, this.option, this.values)
      : min = values.min,
        max = values.max,
        average = (values.average * pow(10, 2)).round() / pow(10, 2),
        total = values.sum;
}
