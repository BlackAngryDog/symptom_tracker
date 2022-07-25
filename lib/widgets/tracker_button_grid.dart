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

class TrackerButtonGrid extends StatefulWidget {
  final Function(Tracker? tracker) onTrackerSelected;
  final Trackable _trackable;
  TrackerButtonGrid(this._trackable, this.onTrackerSelected, {Key? key}) : super(key: key);

  @override
  State<TrackerButtonGrid> createState() => _TrackerButtonGridState();
}

class _TrackerButtonGridState extends State<TrackerButtonGrid> {
  Tracker? _selectedTracker;

  final db = FirebaseFirestore.instance;
  bool test = false;

  int getMaxCount(int length) {
    double d = length.toDouble();

    //if (d % 5 == 0) return 5;
    //if (d % 4 == 0) return 4;
    if (d % 3 == 0) return 3;
    if (d % 2 == 0) return 2;
    return (d / 2).round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        //stream: Tracker.getCollection(_trackable.id ?? "default").where('type', isEqualTo: "counter").snapshots(),
        stream: Tracker.getCollection(widget._trackable.id ?? "default").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Card(
              child: CircularProgressIndicator(),
              color: Colors.transparent,
            );
          } else {
            return GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getMaxCount(snapshot.data?.docs.length ?? 0),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 150,
                childAspectRatio: .1,
              ),
              children: snapshot.data?.docs.map((doc) {
                return GestureDetector(
                  child: TrackerItem(Tracker.fromJson(doc.id, doc.data() as Map<String, dynamic>)),
                  onTap: () => {
                    setState(() {
                      _selectedTracker = Tracker.fromJson(doc.id, doc.data() as Map<String, dynamic>);
                      widget.onTrackerSelected(_selectedTracker);
                    }),
                  },
                );
              }).toList() as List<Widget>,
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
