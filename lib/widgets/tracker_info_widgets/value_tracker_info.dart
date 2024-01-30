import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/date_process_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';

class ValueTrackerDisplay extends StatelessWidget {
  final Tracker _tracker;
  final DateTime start;
  final DateTime end;

  ValueTrackerDisplay(this._tracker, this.start, this.end, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tracker.getValuesFor(start, end),
      builder: (context, snapshot) => snapshot.hasData
          ? getWidget(context, snapshot.data as List<dynamic>)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget getWidget(BuildContext context, List<dynamic> data) {
    var index = 0;
    var spots = data
        .map((e) =>
            FlSpot((index++).toDouble(), double.tryParse(e.toString()) ?? 0))
        .toList();

    return Card(
      child: Column(
        children: [
          FittedBox(child: Text(_tracker.option.title ?? "")),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 56.0),
            child: FittedBox(child: Text(data.lastOrNull ?? "0")),
          )),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 100,
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(enabled: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.blue,
                        preventCurveOverShooting: true,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        spots: spots,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          // TODO - add a trend graph
        ],
      ),
    );
  }
}
