import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:intl/intl.dart';
import 'package:symptom_tracker/model/tracker.dart';

class LineChartData {
  final DateTime time;
  final double? value;

  LineChartData(this.time, this.value);
}

class LineChart extends StatelessWidget {
  final Tracker _tracker;
  LineChart(this._tracker, {Key? key}) : super(key: key) {
    print(' building line chart');
  }

  double scaleMin = 0;
  double scaleMax = 1;
  final _monthDayFormat = DateFormat('MM-dd');

  final _chartData = [
    LineChartData(DateTime.now().add(const Duration(days: -1)), 1),
    LineChartData(DateTime.now().add(const Duration(days: -1)), 2),
    LineChartData(DateTime.now(), 1)
  ];

  Future<List<LineChartData>> _getData() async {
    List<LineChartData> list = [];

    List<DataLog> logs = await _tracker.getLogs(
        DateTime.now().add(const Duration(days: -31)), DateTime.now());
    print(' logs is ${logs.length}');
    for (DataLog log in logs) {
      // TODO - NEED TO JUST DO ONE ENTRY PER DAY
      double? d = double.parse(log.value.toStringAsFixed(2));
      //double? d = double.tryParse(log.value.toString())!.roundToDouble();
      print(' data entry ${log.time}, ${d ?? 0}');
      list.add(LineChartData(log.time, d ?? 0));

      if (d! > scaleMax) scaleMax = (d * 1.5).ceilToDouble();
      if (d! < scaleMin) scaleMin = (d).floorToDouble();
    }
    print(' list is ${list.length}');
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LineChartData>>(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              width: 350,
              height: 200,
              child: Chart(
                data: snapshot.data ?? <LineChartData>[],
                variables: {
                  'time': Variable(
                    accessor: (LineChartData map) => map.time,
                    scale: TimeScale(
                      formatter: (time) => _monthDayFormat.format(time),
                    ),
                  ),
                  'sales': Variable(
                    accessor: (LineChartData data) => data.value ?? 0,
                    scale: LinearScale(min: scaleMin, max: scaleMax),
                  ),
                },
                elements: [
                  LineElement(
                    shape: ShapeAttr(value: BasicLineShape(smooth: true)),
                    size: SizeAttr(value: 3),
                    color: ColorAttr(
                      variable: 'sales',
                      values: Defaults.colors10,
                      updaters: {
                        'groupMouse': {false: (color) => color.withAlpha(100)},
                        'groupTouch': {false: (color) => color.withAlpha(100)},
                      },
                    ),
                  )
                ],
                coord: RectCoord(color: const Color(0xffdddddd)),
                axes: [
                  Defaults.horizontalAxis,
                  Defaults.verticalAxis,
                ],
                selections: {
                  'touchMove': PointSelection(
                    on: {
                      GestureType.scaleUpdate,
                      GestureType.tapDown,
                      GestureType.longPressMoveUpdate
                    },
                    dim: Dim.x,
                  )
                },
                tooltip: TooltipGuide(
                  followPointer: [false, true],
                  align: Alignment.topLeft,
                  offset: const Offset(-20, -20),
                ),
                crosshair: CrosshairGuide(followPointer: [false, true]),
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
