import 'dart:convert';

import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:collection/collection.dart';

class DataProcessManager {
  static Future<Map<String, Map<String, List<double>>>> getData() async {
    DateTime start = DateTimeExt.lastMonth;

    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getDietTracker();

    List<DataLog> dietLogs = await dietTracker.getLogs(
        DateTimeExt.lastMonth, DateTime.now().endOfDay);

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
      // get diet value at this time.
      var diet = dietTracker.getLastValueFor(log.time);

      // if diet is null, skip.
      if (diet == null) continue;

      // get TrackOption
      var trackOption = options.where((e) => e.id == log.optionID).firstOrNull;
      var value = double.tryParse(log.value.toString()) ?? 0;
      var key = trackOption?.title ?? "";
      if (key.isEmpty || value == 0) continue;

      // what was the diet value at this time?
      DataLog? dietLog =
          await dietTracker.getLastEntry(false, before: log.time);

      if (dietLog == null) continue;

      for (var entry in dietLog.value!.entries) {
        if (entry.value == true) {
          map.putIfAbsent(key, () => {});
          map[key]!.putIfAbsent(entry.key, () => []);
          map[key]![entry.key]!.add(value);
          //print(
          //    'insight total: ${trackOption?.title} -${entry.key} - ${log.time} - ${log.value}');
        }
      }
      //map.toString();
      //Map<String, bool> currDiet = jsonDecode(val);

      // print(
      //    'TrackOption: ${trackOption?.title} -${val} - ${log.time} - ${log.value}');
    }

    return map;
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
