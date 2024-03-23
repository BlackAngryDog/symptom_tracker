import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/database_objects/data_log.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';
import 'package:symptom_tracker/views/widgets/log/data_log_item.dart';

class DataLogList extends StatelessWidget {
  final Trackable _trackable;

  const DataLogList(this._trackable, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).copyWith().size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: DataLog.collection(_trackable.id!)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data?.docs.map((doc) {
                return DataLogItem(DataLog.fromJson(
                    doc.id, doc.data() as Map<String, dynamic>));
              }).toList() as List<DataLogItem>,
            );
          }
        },
      ),
    );
  }
}
