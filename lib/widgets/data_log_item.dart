import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';

class DataLogItem extends StatelessWidget {
  final DataLog log;

  const DataLogItem(this.log, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: Text(
            log.title ?? "",
          ),
          subtitle: Text(log.time.toString()),
          trailing: Text(log.value.toString()),
        ),
      ),
    );
  }
}
