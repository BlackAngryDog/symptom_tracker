import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/date_process_manager.dart';

class LineDataChart extends StatelessWidget {
  const LineDataChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataProcessManager.getSummary(),
      builder: (context, snapshot) => snapshot.hasData
          ? buildChart(snapshot.data as List<DataLogSummary>)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
    // TODO - Build chart data from map
  }

  Widget buildChart(List<DataLogSummary> data) {
    return LineChart(
      LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: getTitles(leftTitles: data.map((e) => e.option).toList()),
        borderData: borderData,
        lineBarsData: lineBarsData(data),
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      ),
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData getTitles(
      {List<String>? topTitles,
      List<String>? bottomTitles,
      List<String>? leftTitles,
      List<String>? rightTitles}) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: GetTitles(bottomTitles ?? []),
      ),
      rightTitles: AxisTitles(
        sideTitles: GetTitles(rightTitles ?? []),
      ),
      topTitles: AxisTitles(
        sideTitles: GetTitles(topTitles ?? []),
      ),
      leftTitles: AxisTitles(
        sideTitles: GetTitles(leftTitles ?? []),
      ),
    );
  }

  SideTitles GetTitles(List<String> list) {
    return list.isEmpty
        ? SideTitles(showTitles: false)
        : SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 40,
            getTitlesWidget: (value, meta) =>
                TitleWidgets(list[value.toInt()], meta),
          );
  }

  Widget TitleWidgets(String title, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text = Text(title, style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.blue, width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  List<LineChartBarData> lineBarsData(List<DataLogSummary> data) {
    List<LineChartBarData> list = [];
    for (var entry in data) {
      var lineChartBarData = LineChartBarData(
        isCurved: true,
        color: Colors.blue,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots:
            data.map((e) => FlSpot(list.length.toDouble(), e.average)).toList(),
      );
      list.add(lineChartBarData);
    }
    return list;
  }

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.amber,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.amber.withOpacity(0),
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
        color: Colors.cyan,
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
}
