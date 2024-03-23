import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/managers/date_process_manager.dart';
import 'package:collection/collection.dart';
import 'package:symptom_tracker/painters/line_painter.dart';

class TimeLineItem extends StatelessWidget {

  final DateTime date;
  final List<TimeLineEntry> logs;
  final List<TimeLineEntry>? comparisonLog;

  const TimeLineItem(this.date, this.logs, {this.comparisonLog, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<_dataVo> filteredLogs = [];

    if (logs.isEmpty) {
      return Container(
        child: Text(date.dateOnly.toString()),
      );
    }

    for (var entry in logs) {
      TimeLineEntry? comp = comparisonLog
          ?.firstWhereOrNull((element) => element.option == entry.option);
      var data = _dataVo(entry, comp);
      if (data.showEntry) filteredLogs.add(data);
    }

    return Column(
      children: [
        Text(logs.first.diet),
        for (var entry in filteredLogs) getLogEntry(entry, context),
      ],
    );
  }

  Widget getLogEntry(_dataVo entry, BuildContext context) {
    var width = 0.1 * entry.advChange;
    /*
    return CustomPaint(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        child: Center(child: Text("${entry.title} ${entry.advChange > 0 ? "+${entry.advChange.toString()}" : entry.advChange.toString()}" ?? "")),
      ),
      painter: LinePainter(width),
    );
  */
    return CustomPaint(
      child: Card(
        child: ListTile(
          title: Text(
            "${entry.title} : ${date.dateOnly.toString()}",
          ),
          subtitle: Text(entry.adv.toString()),
          trailing: CustomPaint(
            painter: (entry.advChange != entry.adv) ? LinePainter(width) : null,
            child: SizedBox(
                width: 200,
                height: 30,
                child: Center(
                  child: entry.advChange != entry.adv
                      ? Text(entry.advChange > 0
                          ? "+${entry.advChange.toString()}"
                          : entry.advChange.toString())
                      : null,
                )),
          ),
        ),
      ),
    );
  }
}

class _dataVo {
  final TimeLineEntry current;
  final TimeLineEntry? comparison;

  late String title;
  late double adv;
  late double advChange;

  _dataVo(this.current, this.comparison) {
    title = current.option;
    adv = current.values.average;
    advChange = adv - (comparison?.average ?? 0);
  }

  bool get showEntry => advChange != 0;
}
