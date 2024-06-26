import 'dart:async';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/enums/tracker_enums.dart';
import 'package:symptom_tracker/model/database_objects/data_log.dart';
import 'package:symptom_tracker/managers/date_process_manager.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';

class DietChartData {
  //final DateTime time;
  final String name;
  final num value;
  final int index;

  DietChartData(this.name, this.value, this.index);
}

class DietTimelineData {
  final DateTime start;
  final DateTime end;
  final DataLog dietLog;
  final Map<Tracker, List<DataLog>> history;

  DietTimelineData(this.start, this.end, this.dietLog, this.history);
}

class DietData {
  final String symptom;
  final Map<String, List<DataLog>> history = <String, List<DataLog>>{};

  DietData(this.symptom);

  void addLog(String dietOption, DataLog log) {
    if (!history.containsKey(dietOption)) {
      history[dietOption] = <DataLog>[];
    }
    history[dietOption]!.add(log);
  }
}

class DietChart extends StatefulWidget {
  final int duration;
  DietChart(this.duration, {Key? key}) : super(key: key) {
    print(' building diet chart');
  }

  @override
  State<DietChart> createState() => _DietChartState();
}

class _DietChartState extends State<DietChart> {
  Trackable get _selectedTarget => EventManager.selectedTarget;
  Tracker? get _selectedTracker => EventManager.selectedTracker;

  late StreamSubscription trackableSubscription;

  List<PieChartSectionData> _pieData = [];

  @override
  void initState() {
    super.initState();
    _getData();
    //trackableSubscription = EventManager.stream.listen((event) {
    //  if (_selectedTracker != null) _getData();
    //});
  }

  @override
  void dispose() {
    super.dispose();
    //trackableSubscription.cancel();
  }

  double scaleMin = 0;
  double scaleMax = 1;

  final Map<String, List<DietChartData>> _chartMap =
      <String, List<DietChartData>>{};

  var _chartData = [
    DietChartData("test 1", 10, 1),
    DietChartData("test 2", 20, 2),
    DietChartData("test 3", 30, 3),
    DietChartData("test 4", 10, 4),
    DietChartData("test 5", 40, 5),
    DietChartData("test 6", 30, 6),
  ];

  final roseData = [
    {'value': 20, 'name': 'rose 1'},
    {'value': 10, 'name': 'rose 2'},
    {'value': 24, 'name': 'rose 3'},
    {'value': 12, 'name': 'rose 4'},
    {'value': 20, 'name': 'rose 5'},
    {'value': 15, 'name': 'rose 6'},
    {'value': 22, 'name': 'rose 7'},
    {'value': 29, 'name': 'rose 8'},
  ];

  //final Map<String, List<PieChartSectionData>> _pieSections = <String, List<PieChartSectionData>>{};

  Future<List<PieChartSectionData>> _getData() async {
    // TODO - GET ALL OTHER DATA LOGS TO COMPARE WITH EACH FOOD OPTION!?
    Map<String, List<PieChartSectionData>> pieSections =
        <String, List<PieChartSectionData>>{};
    // Read data as a list of diet changes.
    Tracker dietTracker = _selectedTarget.getTracker(TrackerType.diet)!;

    // TODO - setup timeframe
    DateTime start = DateTime.now().subtract(Duration(days: widget.duration));
    DateTime end = DateTime.now();
    List<DataLog> dietLogs = await dietTracker.getLogs(start, DateTime.now());

    //Make sure data is sorted by time
    dietLogs.sort((a, b) => a.time.compareTo(b.time));

    // map to symptom, diet title, logs.
    List<DietData> dietDataList = [];

    Map<String, Duration> logEntries =
        await DataProcessManager.getDietFor(start, end);

    // get array of colours
    List<PieChartSectionData> sections = [];
    for (var entry in logEntries.entries) {
      //TODO - map key (diet name) to duration for chart
      //pieSections.putIfAbsent(entry.key, () => null)
      sections.add(PieChartSectionData(
        title: entry.key,
        value: entry.value.inMinutes.toDouble(),
        color: Colors.redAccent,
        radius: 80,
        titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff)),
      ));

      setState(() {
        _pieData = sections;
      });
    }
    return _pieData;

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

    return _pieData;
  }

/*
  List<Widget> getFLPieCharts() {
    List<Widget> list = [];
    //i<5, pass your dynamic limit as per your requirment
    print('found ${_pieSections.entries.length} pie entries');
    for (MapEntry<String, List<PieChartSectionData>> entry in _pieSections.entries) {
      list.add(Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 100,
            height: 100,
            child: PieChart(
              PieChartData(
                // read about it in the PieChartData section
                sections: entry.value,
                centerSpaceRadius: 10,
                sectionsSpace: 10,
              ),
              swapAnimationDuration: Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear, // Optional
            ),
          ),
        ],
      ));
    }

    return list; // all widget added now retrun the list here
  }
*/
  @override
  Widget build(BuildContext context) {
    return Card(
      child: PieChart(
        PieChartData(
          // read about it in the PieChartData section
          sections: _pieData,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
        ),
        swapAnimationDuration: const Duration(milliseconds: 150), // Optional
        swapAnimationCurve: Curves.linear, // Optional
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: getFLPieCharts(),
            );
          } else {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              color: Colors.black,
              width: 100,
              height: 100,
            );
          }
        });
  }

 */
}
