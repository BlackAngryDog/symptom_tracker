import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:intl/intl.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:collection/collection.dart';

class DietChartData {
  final String name;
  final double value;

  DietChartData(this.name, this.value);
}

class DietTimelineData {
  final DateTime start;
  final DateTime end;
  final DataLog dietLog;
  final Map<Tracker, List<DataLog>> history;

  DietTimelineData(this.start, this.end, this.dietLog, this.history);
}

class DietChart extends StatelessWidget {
  final Tracker _tracker;
  DietChart(this._tracker, {Key? key}) : super(key: key) {
    print(' building diet chart');
  }

  double scaleMin = 0;
  double scaleMax = 1;
  final _monthDayFormat = DateFormat('MM-dd');

  final _chartData = [
    DietChartData("test 1", 10),
    DietChartData("test 2", 20),
    DietChartData("test 3", 30),
    DietChartData("test 4", 10),
    DietChartData("test 5", 40),
    DietChartData("test 6", 30),
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

  Future<List<DietChartData>> _getData() async {
    // TODO - GET ALL OTHER DATA LOGS TO COMPARE WITH EACH FOOD OPTION!

    // Read data as a list of diet changes.
    List<DataLog> dietLogs =
        await _tracker.getLogs(DateTimeExt.lastMonth, DateTime.now());

    //Make sure data is sorted by time
    dietLogs.sort((a, b) => a.time.compareTo(b.time));

    DateTime start = DateTimeExt.lastMonth;

    final List<Tracker> trackers =
        await Tracker.getCollection(_tracker.trackableID)
            .where('title', isNotEqualTo: _tracker.title)
            .get()
            .then((data) {
      List<Tracker> log = data.docs.map((doc) {
        return Tracker.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return [];
    });

    List<DietTimelineData> timeline = [];
    // extract date data to then read other trackers to compare.
    for (DataLog data in dietLogs) {
      Map<Tracker, List<DataLog>> history = <Tracker, List<DataLog>>{};
      for (Tracker t in trackers) {
        history[t] = await t.getLogs(start, data.time);
      }

      timeline.add(DietTimelineData(start, data.time, data, history));
      start = data.time;
    }

    return _chartData;

    /*
    List<DietChartData> list = [];

    List<DataLog> logs = await _tracker.getLogs(
        DateTime.now().add(const Duration(days: -31)), DateTime.now());

    // logs.clear();
    if (logs.isEmpty) return list;

    print(' logs is ${logs.length}');
    for (DataLog log in logs) {
      // TODO - NEED TO JUST DO ONE ENTRY PER DAY
      double d = double.parse(
          log.value is String ? log.value : log.value.toStringAsFixed(2));
      //double? d = double.tryParse(log.value.toString())!.roundToDouble();
      print(' data entry ${log.time}, d');
      list.add(DietChartData(log.time, d));

      if (d > scaleMax) scaleMax = (d * 1.5).ceilToDouble();
      if (d < scaleMin) scaleMin = (d).floorToDouble();
    }
    // ADD IN TODAY IF NOT AVAILABLE

    DataLog last = logs.last;
    print('checking last ${last.time}');
    if (last.time.isBefore(DateTimeExt.today)) {
      print('adding today');

      double d = double.parse(
          last.value is String ? last.value : last.value.toStringAsFixed(2));
      list.add(DietChartData(DateTime.now(), d));
    }

    print(' list is ${list.length}');
    return list;

     */
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              width: 350,
              height: 200,
              child: Chart(
                data: snapshot.data ?? dynamic,
                variables: {
                  'name': Variable(
                    accessor: (DietChartData map) => map.name as String,
                  ),
                  'value': Variable(
                    accessor: (DietChartData map) => map.value as double,
                    scale: LinearScale(min: 0, marginMax: 0),
                  ),
                },
                elements: [
                  IntervalElement(
                    label: LabelAttr(
                        encoder: (tuple) => Label(tuple['name'].toString())),
                    shape: ShapeAttr(
                        value: RectShape(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    )),
                    color:
                        ColorAttr(variable: 'name', values: Defaults.colors10),
                    elevation: ElevationAttr(value: 5),
                  )
                ],
                coord: PolarCoord(startRadius: 0.15),
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              width: 350,
              height: 200,
            );
          }
        });
  }
}
