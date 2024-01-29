import 'dart:async';
import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:symptom_tracker/model/date_process_manager.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';

import 'package:collection/collection.dart';
import 'dart:math';


class LineDataChart extends StatefulWidget {

  final DateTime? date;
  final int span;
  final int segments;

  LineDataChart({this.span = 30, this.segments = 7, this.date, Key? key}) : super(key: key);

  @override
  State<LineDataChart> createState() => _LineDataChartState();
}

class _LineDataChartState extends State<LineDataChart> {
  Trackable trackable = EventManager.selectedTarget;
  List<String> symptoms = [];
  List<String> diet = [];

  late StreamSubscription trackerSubscription;

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    trackerSubscription = EventManager.stream.listen((event) {
      if (event.event == EventType.trackerChanged) {
        setState(() {});
      }
    });
    //getCurrValue();
  }

  @override
  Widget build(BuildContext context) {


    DateTime startDate = widget.date?.subtract(Duration(days: widget.span))?? DateTime.now().subtract(Duration(days: widget.span));
    DateTime endDate = widget.date??DateTime.now();

    return FutureBuilder(
      future: DataProcessManager.getTrackersFor(startDate, endDate),
      builder: (context, snapshot) => snapshot.hasData
          ? buildSymptomsAdvOverTimeChart(
              snapshot.data as List<LogTimeLineEntry>)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
    // TODO - Build chart data from map
  }

  Widget buildSymptomsAdvOverTimeChart(List<LogTimeLineEntry> data) {
    List<LineChartBarData> dataList = [];
    List<Color> colours = [
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.purple
    ];

    // get array of colours
    List<String> symptoms = [];
    for (var log in data) {
      if (symptoms.contains(log.title) || log.title == "Weight ") continue;
      symptoms.add(log.title);
    }

    double minVal = double.maxFinite;
    double maxVal = 0;

    for (var option in symptoms) {
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

      // filter out data for curr symptom
      var timeline = data.where((element) => element.title == option).toList();

      for( var i = 0; i< timeline.length; i+=widget.segments){
          var list = timeline
              .where((e) => timeline.indexOf(e) >= i && timeline.indexOf(e) < i + widget.segments)
              .map((element) => element.value).toList();

          chartData.spots.add(FlSpot((i/widget.segments).toDouble(), list.isEmpty ? 0.0 : list.average));

          // set min to list.min if lower
          minVal = min(list.average, minVal);
          maxVal = max(list.average+1, maxVal);

      }

      dataList.add(chartData);
    }

    // Todo - make titles dynamic
    var numDays = dataList.first.spots.length;

    List<String> bottomTitles = List.filled(numDays, " ");
    List<String> leftTitles = [];
    while (minVal <= maxVal) {
      leftTitles.add((minVal++).toString());
    }
    // bottom time
    // left symptoms
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: lineTouchData1,
                gridData: gridData,
                titlesData: getTitles(
                    bottomTitles: bottomTitles,
                    leftTitles: leftTitles),
                borderData: borderData,
                lineBarsData: dataList,
                minX: 0,
                maxX: bottomTitles.length.toDouble() - 1,
                maxY: leftTitles.length.toDouble()-1, // todo - need to adjust these based on visible data
                minY: 0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(symptoms.length, (index) {
            return Row(
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colours[index],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    symptoms[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colours[index],
                    ),
                  ),
                ],
              );
            },),
          ),
        ],
      ),
    );
  }

  Widget buildSymptomsAdvOverDietChart(List<DataLogSummary> data) {
    List<LineChartBarData> dataList = [];
    List<Color> colours = [
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.purple
    ];
    // get array of colours
    Map<String, List<DataLogSummary>> map = {};
    for (var entry in data) {
      map.putIfAbsent(entry.option, () => []);
      map[entry.option]?.add(entry);
    }

    symptoms = map.keys.toList();

    for (var option in map.keys) {
      diet.addAll(
          map[option]!.where((e) => !diet.contains(e.diet)).map((e) => e.diet));

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

      for (var dietName in diet) {
        var x = diet.indexOf(dietName).toDouble();
        var y = map[option]
                ?.where((element) => element.diet == dietName)
                .firstOrNull
                ?.average ??
            0;
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
          titlesData: getTitles(
              bottomTitles: diet, leftTitles: ["0", "1", "2", "3", "4", "5"]),
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
        spots: map[option]!
            .map((e) =>
                FlSpot(map[option]?.indexOf(e).toDouble() ?? 0, e.average))
            .toList(),
      );
      dataList.add(chartData);

      symptoms.add(option);
    }
    diet = map.keys.toList();

    return dataList;
  }
}
