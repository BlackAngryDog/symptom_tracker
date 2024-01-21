import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/date_process_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';

class TimeLineItem extends StatelessWidget {
  final TimeLineEntry log;

  const TimeLineItem(this.log, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TrackOption.load(log.option ?? ""),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var option = snapshot.data as TrackOption;
            //var diet = log.diet ?? "";

            return Card(
              child: ListTile(
                title: Text(
                  log.diet,
                ),
                subtitle: Text(log.option.toString()),
                trailing: Text(log.average.toString()),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
