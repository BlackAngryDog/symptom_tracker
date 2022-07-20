import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:intl/intl.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:collection/collection.dart';

class LineChartWidgetData {
  final DateTime time;
  final double? value;

  LineChartWidgetData(this.time, this.value);
}

class LineChartWidget extends StatelessWidget {
  final Tracker? _tracker;

  LineChartWidget(this._tracker, {Key? key}) : super(key: key) {
    print(' building line chart');
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  double scaleXMin = 0;
  double scaleXMax = 1;
  double scaleYMin = 0;
  double scaleYMax = 1;
  final _monthDayFormat = DateFormat('MM-dd');

  final _chartData = [
    LineChartWidgetData(DateTime.now().add(const Duration(days: -1)), 1),
    LineChartWidgetData(DateTime.now().add(const Duration(days: -1)), 2),
    LineChartWidgetData(DateTime.now(), 1)
  ];

  final List<FlSpot> _spots = [];

  Future<List<LineChartWidgetData>> _getData() async {
    List<LineChartWidgetData> list = [];
    if (_tracker == null) return list;

    DateTime startDate = DateTimeExt.lastWeek.add(Duration(days: 0));
    DateTime endDate = startDate.add(const Duration(days: 7)).endOfDay;
    scaleXMax = 7;

    List<DataLog> logs = await _tracker!.getLogs(startDate, endDate);

    if (logs.isEmpty) return list;

    DataLog? start = await _tracker!.getLastEntry(false, before: startDate);
    if (start != null) {
      double d = double.parse(start.value is String ? start.value : start.value.toStringAsFixed(2));
      _spots.add(FlSpot(0, getValueFromLog(start)));
    } else {
      _spots.add(FlSpot(0, 0));
    }

    // logs.clear();

    print(' logs is ${logs.length}');
    for (DataLog log in logs) {
      // TODO - NEED TO JUST DO ONE ENTRY PER DAY
      double d = double.parse(log.value is String ? log.value : log.value.toStringAsFixed(2));
      //double? d = double.tryParse(log.value.toString())!.roundToDouble();
      print(' data entry ${log.time}, d');
      list.add(LineChartWidgetData(log.time, d));

      double day = double.parse(log.time.difference(startDate).inDays.toString());
      FlSpot? currSpot = _spots.where((element) => element.x == day).firstOrNull;
      if (currSpot != null) _spots.remove(currSpot);

      _spots.add(FlSpot(day, getValueFromLog(log)));
    }
    // ADD IN TODAY IF NOT AVAILABLE

    DataLog last = logs.last;
    print('checking last ${last.time}');
    if (last.time.isBefore(endDate.endOfDay)) {
      print('adding today');

      double d = double.parse(last.value is String ? last.value : last.value.toStringAsFixed(2));
      list.add(LineChartWidgetData(endDate, d));
      double day = double.parse(endDate.dateOnly.difference(startDate).inDays.toString());
      //_spots.add(FlSpot(day, getValueFromLog(last)));
    }

    print(' list is ${list.length}');
    return list;
  }

  double getValueFromLog(DataLog log) {
    double d = double.parse(log.value is String ? log.value : log.value.toStringAsFixed(2));

    if (d > scaleYMax) scaleYMax = (d).ceilToDouble() + 1;
    if (d < scaleYMin) scaleYMin = (d).floorToDouble();

    return d;
    _spots.add(FlSpot(0, d));
  }

  Widget FLLineChart() {
    return LineChart(mainData());
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            //getTitlesWidget: leftTitleWidgets,
            reservedSize: 20,
          ),
        ),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: scaleXMin,
      maxX: scaleXMax,
      minY: scaleYMin,
      maxY: scaleYMax,
      lineBarsData: lineBarsData1,
    );
  }

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: .1,
        color: const Color(0xff4af699),
        barWidth: 6,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: true),
        spots: _spots,
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: const Color(0xffaa4cfc),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: const Color(0x00aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff27b6fc),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  /*
      return ;

       */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LineChartWidgetData>>(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: MediaQuery.of(context).copyWith().size.width,
              child: Card(
                color: Colors.white60,
                elevation: 5,
                child: Container(
                  margin: const EdgeInsets.all(25),
                  width: 350,
                  height: 200,
                  child: FLLineChart(), //lineChart(snapshot.data ?? []);
                ),
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
