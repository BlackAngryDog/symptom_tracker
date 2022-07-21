import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/data_log_item.dart';
import 'package:symptom_tracker/widgets/line_chart.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';

class TrackerList extends StatefulWidget {
  final Trackable _trackable;
  TrackerList(this._trackable, {Key? key}) : super(key: key);

  @override
  State<TrackerList> createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerList> {
  Tracker? _selectedTracker;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        //stream: Tracker.getCollection(_trackable.id ?? "default").where('type', isEqualTo: "counter").snapshots(),
        stream: Tracker.getCollection(widget._trackable.id ?? "default").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                _selectedTracker == null ? SizedBox() : LineChartWidget(_selectedTracker),
                Expanded(
                  child: ListView(
                    children: snapshot.data?.docs.map((doc) {
                      return GestureDetector(
                        child: TrackerItem(Tracker.fromJson(doc.id, doc.data() as Map<String, dynamic>)),
                        onTap: () => {
                          setState(() {
                            _selectedTracker = Tracker.fromJson(doc.id, doc.data() as Map<String, dynamic>);
                          }),
                        },
                      );
                    }).toList() as List<Widget>,
                  ),
                ),
              ],
            );
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
