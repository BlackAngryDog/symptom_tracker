import 'package:flutter/material.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/widgets/data_log_item.dart';

class DataLogList extends StatelessWidget {
  const DataLogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: FirebaseDatabaseListView(
        query: DatabaseTools.getRef(DataLog().getEndpoint()),
        itemBuilder: (context, snapshot) {
          DataLog logVo = DataLog.fromJson(
              snapshot.key, snapshot.value as Map<dynamic, dynamic>);
          return DataLogItem(logVo);
        },
      ),
    );
  }
}
