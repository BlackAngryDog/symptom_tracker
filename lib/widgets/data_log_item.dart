import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/track_option.dart';

class DataLogItem extends StatelessWidget {
  final DataLog log;

  const DataLogItem(this.log, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: TrackOption.load(log.optionID??""),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var option = snapshot.data as TrackOption;
            return  Card(
              child: ListTile(
                title: Text(
                  option.title ?? "",
                ),
                subtitle: Text(log.time.toString()),
                trailing: Text(log.value.toString()),
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
