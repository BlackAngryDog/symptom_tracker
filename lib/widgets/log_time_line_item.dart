import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/date_process_manager.dart';
import 'package:collection/collection.dart';
import 'package:symptom_tracker/painters/line_painter.dart';

class LogTimeLineItem extends StatelessWidget {

  final DateTime date;
  final List<LogTimeLineEntry> logs;
  final List<LogTimeLineEntry>? comparisonLog;

  const LogTimeLineItem(this.date, this.logs, {this.comparisonLog, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<_dataVo> filteredLogs = [];

    if (logs.isEmpty) {
      return Container(
        child: Center(child: Text(date.dateOnly.toString())),
      );
    }

    for (var entry in logs) {
      LogTimeLineEntry? comp = comparisonLog
          ?.lastWhereOrNull((element) => element.title == entry.title);
      var data = _dataVo(entry, comp);
      var diff = comp?.date.difference(entry.date).inDays;
      if (data.showEntry || comp == entry) {
        filteredLogs.add(data);
      } else {
        print("test");
      }

    }

    return Column(
      children: [
        for (var entry in filteredLogs) getLogEntry(entry, context),
      ],
    );
  }

  Widget getLogEntry(_dataVo entry, BuildContext context) {
    var width = 0.1 * entry.advChange;// == 0 ? entry.adv : entry.advChange;

    return CustomPaint(
      painter: LinePainter(width),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 30,
        child: Text("${entry.title} ${entry.advChange > 0
            ? "+${entry.advChange.toString()}"
            : entry.advChange.toString()}" ?? "", textAlign: entry.advChange < 0 ? TextAlign.start : TextAlign.end),
      ),
    );

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
                width: 100,
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
  final LogTimeLineEntry current;
  final LogTimeLineEntry? comparison;

  late String title;
  late double adv;
  late double advChange;

  _dataVo(this.current, this.comparison) {
    title = current.title;
    adv = current.value;
    advChange = adv - (comparison?.value ?? 0);
  }

  bool get showEntry => advChange != 0;
}
