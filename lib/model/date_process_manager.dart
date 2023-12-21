import 'dart:convert';

import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:collection/collection.dart';

class DataProcessManager {
  static Future<List<Object>> getData() async {
    // TODO - GET ALL OTHER DATA LOGS TO COMPARE WITH EACH FOOD OPTION!?
    // Map<String, List<PieChartSectionData>> pieSections =
    //   <String, List<PieChartSectionData>>{};
    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getDietTracker();
    List<DataLog> dietLogs = await dietTracker.getLogs(
        DateTimeExt.lastMonth, DateTime.now().endOfDay);
    //Make sure data is sorted by time
    //dietLogs.sort((a, b) => a.time.compareTo(b.time));

    // get all other trackers.
    //List<TrackOption> options = EventManager.selectedTarget.trackers.where((element) => element.trackType != dietTracker.option.trackType).toList(growable: false);
    List<TrackOption> options = await TrackOption
        .getOptions(); //.where((element) => element.trackType != dietTracker.option.trackType).toList(growable: false);
    DateTime start = DateTimeExt.lastMonth;
    // Get all logs for target
    var logs = await EventManager.selectedTarget
        .getDataLogs(start, DateTime.now().endOfDay);

    var map = <String, Map<String, List<double>>>{};
    // for each TrackOption, get logs and compare to diet logs.

    for (var log in logs) {
      //print('insight log entry: ${log.optionID} - ${log.time} - ${log.value}');

      var diet = dietTracker.getLastValueFor(log.time);
      // if diet is null, skip.
      if (diet == null) continue;

      // get TrackOption
      var trackOption = options.where((e) => e.id == log.optionID).firstOrNull;
      var value = double.tryParse(log.value.toString()) ?? 0;
      var key = trackOption?.title ?? "";
      if (key.isEmpty || value == 0) continue;

      map.putIfAbsent(key, () => {});

      // what was the diet value at this time?
      DataLog? dietLog =
          await dietTracker.getLastEntry(false, before: log.time);
      if (dietLog == null) continue;

      for (var entry in dietLog.value!.entries) {
        if (entry.value == true) {
          map[key]!.putIfAbsent(entry.key, () => []);
          map[key]![entry.key]!.add(value);
          print(
              'insight total: ${trackOption?.title} -${entry.key} - ${log.time} - ${log.value}');
        }
      }
      //map.toString();
      //Map<String, bool> currDiet = jsonDecode(val);

      // print(
      //    'TrackOption: ${trackOption?.title} -${val} - ${log.time} - ${log.value}');
    }
    for (var dietMap in map.entries) {
      for (var entry in dietMap.value.entries) {
        var v = entry.value.average;
        print(
            'insight average: ${dietMap.key} - ${entry.key} - ${entry.value.average}');
      }
    }

/*
    // map to symptom, diet title, logs.
    List<DietData> dietDataList = [];

    // extract date data to then read other trackers to compare.
    for (DataLog data in dietLogs) {
      // for (Tracker t in trackers) {
      List<DataLog> trackerLogs =
          await _selectedTracker!.getLogs(start, data.time);

      Map<String, bool> options = Map<String, bool>.from(data.value);
      for (DataLog trackerLog in trackerLogs) {
        for (String option in options.keys) {
          if (options[option] == true) {
            DietData? data = dietDataList
                .where((element) =>
                    element.symptom == _selectedTracker!.option.title)
                .firstOrNull;
            if (data == null) {
              dietDataList
                  .add(data = DietData(_selectedTracker!.option.title ?? ""));
            }
            data.addLog(option, trackerLog);
          }
        }
        // }
      }

      //timeline.add(DietTimelineData(start, data.time, data, history));
      start = data.time;
    }

    for (DietData data in dietDataList) {
      for (MapEntry entry in data.history.entries) {
        num total = 0;
        if (_chartMap[data.symptom] == null) _chartMap[data.symptom] = [];

        for (DataLog log in entry.value) {
          num v =
              num.parse(log.value is String ? log.value : log.value.toString());
          total += v;
          // int index =
          //     _chartMap[data.symptom]!.where((element) => element.name == entry.key).toList(growable: false).length;
          // _chartMap[data.symptom]!.add(DietChartData(entry.key, v, index));
        }

        // Get adverage value.
        _chartMap[data.symptom]!.add(
            DietChartData(entry.key, total / data.history.entries.length, 0));
        if (pieSections[data.symptom] == null) pieSections[data.symptom] = [];
        pieSections[data.symptom]!.add(PieChartSectionData(
          title: entry.key,
          value: total / data.history.entries.length,
          color: Colors.redAccent,
          radius: 40,
          titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff)),
        ));
        setState(() {
          _pieData = pieSections[data.symptom] ?? [];
        });
      }

      _chartData = _chartMap[data.symptom] ?? _chartData;
    }
    print(' got chart data');
*/
    return List<Object>.empty();
  }
}
