import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/date_process_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';

class TimeLineItem extends StatelessWidget {
  final List<TimeLineEntry> logs;

  const TimeLineItem(this.logs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(logs.first.diet),
        for (var entry in logs)
          Card(
            child: ListTile(
              title: Text(
                entry.option ?? "",
              ),
              subtitle: Text(entry.endDateTime.toString()),
              trailing: Text(entry.max.toString()),
            ),
          ),
      ],
    );
  }
}
