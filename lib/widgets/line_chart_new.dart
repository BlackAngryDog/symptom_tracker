import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/date_process_manager.dart';

class LineDataChart extends StatelessWidget {
  LineDataChart({Key? key}) : super(key: key);

  List<String> symptoms = [];
  List<String> diet = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataProcessManager.getTimeLine(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()),
      builder: (context, snapshot) => snapshot.hasData
          ? buildSymptomsAdvOverTimeChart(snapshot.data as List<LogTimeLineEntry>)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
    // TODO - Build chart data from map
  }

  Widget buildSymptomsAdvOverTimeChart(List<LogTimeLineEntry> data) {

    List<LineChartBarData> dataList = [];
    List<Color> colours = [Colors.blue, Colors.red,Colors.yellow, Colors.green, Colors.orange, Colors.pink, Colors.purple];
    List<String> days = ["1","2","2","4","5","6","7"];
    // get array of colours
    List<String> symptoms = [];
    for (var log in data){
      if (symptoms.contains(log.title)) continue;
      symptoms.add(log.title);
    }

    // TODO - need to build up a data set for all days between start and end with filler data for missing days

    for (var option in symptoms) {

      //diet.addAll(map[option]!.where((e) => !diet.contains(e.diet) ).map((e) => e.diet));

      var chartData = LineChartBarData(
        isCurved: true,
        color: colours[0],
        preventCurveOverShooting: true,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [],
        //show: option == "Fits", // Todo add filters

      );

      var timeline = data.where((element) => element.title == option).toList();

      int day = 7;
      while (++day >= 7){
        // Get log from timeline closes to datetime.now - day to get value
        var greater = timeline.toList()..sort((a,b) => a.date.difference(DateTime.now()).inDays);

        var x = day.toDouble();
        var y = greater.firstOrNull!.value;
        chartData.spots.add(FlSpot(x, y));
      }

      dataList.add(chartData);


    }



    // bottom time
    // left symptoms
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineTouchData: lineTouchData1,
          gridData: gridData,
          titlesData: getTitles(bottomTitles: days, leftTitles: ["0","1","2","3","4","5"]),
          borderData: borderData,
          lineBarsData: dataList,
          minX: 0,
          maxX: days.length.toDouble() - 1,
          maxY: 5, // todo - need to adjust these based on visible data
          minY: 0,
        ),
      ),
    );
  }

  Widget buildSymptomsAdvOverDietChart(List<DataLogSummary> data) {

    List<LineChartBarData> dataList = [];
    List<Color> colours = [Colors.blue, Colors.red,Colors.yellow, Colors.green, Colors.orange, Colors.pink, Colors.purple];
    // get array of colours
    Map<String, List<DataLogSummary>> map = {};
    for (var entry in data) {
      map.putIfAbsent(entry.option, () => []);
      map[entry.option]?.add(entry);
    }

    symptoms = map.keys.toList();

    for (var option in map.keys) {

      diet.addAll(map[option]!.where((e) => !diet.contains(e.diet) ).map((e) => e.diet));

      var chartData = LineChartBarData(
        isCurved: true,
        color: colours[symptoms.indexOf(option)],
        preventCurveOverShooting: true,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [],
        //show: option == "Fits", // Todo add filters

      );

      for (var dietName in diet){
        var x = diet.indexOf(dietName).toDouble();
        var y = map[option]?.where((element) => element.diet == dietName).firstOrNull?.average??0;
        chartData.spots.add(FlSpot(x, y));

      }

      dataList.add(chartData);


    }



    // bottom time
    // left symptoms
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineTouchData: lineTouchData1,
          gridData: gridData,
          titlesData: getTitles(bottomTitles: diet, leftTitles: ["0","1","2","3","4","5"]),
          borderData: borderData,
          lineBarsData: dataList,
          minX: 0,
          maxX: diet.length.toDouble() - 1,
          maxY: 5, // todo - need to adjust these based on visible data
          minY: 0,
        ),
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
      fontSize: 8,

    );
    Widget text = Text(title, style: style, textAlign: TextAlign.end);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
      angle: 0,
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
    List<LineChartBarData> dataList = [];

    Map<String, List<DataLogSummary>> map = {};
    for (var entry in data) {
      map.putIfAbsent(entry.diet, () => []);
      map[entry.diet]?.add(entry);

    }

    for (var option in map.keys) {
      var chartData = LineChartBarData(
          isCurved: true,
          color: Colors.blue,
          barWidth: 8,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: map[option]!.map((e) => FlSpot(map[option]?.indexOf(e).toDouble()??0, e.average)).toList(),
      );
      dataList.add(chartData);

      symptoms.add(option);


    }
    diet = map.keys.toList();

    return dataList;
  }

}
