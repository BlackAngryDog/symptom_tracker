import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/tracker.dart';

class DataProcessManager {
  static Future<List<Object>> getData() async {
    // TODO - GET ALL OTHER DATA LOGS TO COMPARE WITH EACH FOOD OPTION!?
    // Map<String, List<PieChartSectionData>> pieSections =
    //   <String, List<PieChartSectionData>>{};
    // Read data as a list of diet changes.
    Tracker dietTracker = EventManager.selectedTarget.getDietTracker();
    List<DataLog> dietLogs =
        await dietTracker.getLogs(DateTimeExt.lastMonth, DateTime.now());
    //Make sure data is sorted by time
    dietLogs.sort((a, b) => a.time.compareTo(b.time));

    // get all other trackers.
    //List<TrackOption> options = EventManager.selectedTarget.trackers.where((element) => element.trackType != dietTracker.option.trackType).toList(growable: false);
    List<TrackOption> options = await TrackOption
        .getOptions(); //.where((element) => element.trackType != dietTracker.option.trackType).toList(growable: false);

    // Get all logs for target
    var logs = await EventManager.selectedTarget
        .getDataLogs(DateTimeExt.lastMonth, DateTime.now());

    DateTime start = DateTimeExt.lastMonth;

    // for each TrackOption, get logs and compare to diet logs.
    for (var log in logs) {
      var diet = dietTracker.getLastValueFor(log.time);
      // if diet is null, skip.
      if (diet == null) continue;

      // get TrackOption
      var trackOption =
          options.where((element) => element.id == log.optionID).firstOrNull;
      var value = log.value;

      print('TrackOption: ${trackOption?.title} - ${log.time} - ${log.value}');
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
