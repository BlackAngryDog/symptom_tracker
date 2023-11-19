// stateless widget that displays the tracker for the week
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/widgets/data_log_item.dart';

class TrackerWeek extends StatelessWidget {
  final Trackable _trackable;

  const TrackerWeek(this._trackable, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).copyWith().size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: DataLog.getCollection(_trackable.id ?? "Default")
            .orderBy('time', descending: true)
            .startAt([DateTime.now().subtract(const Duration(days: 7))])
            .endAt([DateTime.now()])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {

            var list = snapshot.data?.docs.map((doc) {
              return DataLogItem(DataLog.fromJson(
                  doc.id, doc.data() as Map<String, dynamic>));
            }).toList() as List<DataLogItem>;

            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  bool isSameDate = true;

                  final DateTime date = list[index].log.time;
                  final item = list[index];
                  if (index == 0) {
                    isSameDate = false;
                  } else {
                    final DateTime prevDate = list[index - 1].log.time;
                    isSameDate = date.isSameDate(prevDate);
                  }
                  if (index == 0 || !(isSameDate)) {
                    return Column(children: [
                      // get day of week as a string
                      Text(date.dayOfWeek()),
                      list[index]
                    ]);
                  } else {
                    return list[index];
                  }
                });
          }
        },
      ),

      /*child: FirebaseDatabaseListView(
        query: DatabaseTools.getRef(Tracker().getEndpoint()),
        itemBuilder: (context, snapshot) {
          Tracker tracker = Tracker.fromJson(
              snapshot.key, snapshot.value as Map<String, dynamic>);
          return TrackerItem(tracker);
        },
      ),

       */
    );
  }
}
