import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/data_log_item.dart';
import 'package:symptom_tracker/widgets/line_chart.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';

class TrackerControlList extends StatefulWidget {
  const TrackerControlList({Key? key}) : super(key: key);

  @override
  State<TrackerControlList> createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerControlList> {
  Tracker? _selectedTracker;

  final db = FirebaseFirestore.instance;

  late final List<Tracker> _trackers;

  @override
  initState() {
    super.initState();
    _trackers = EventManager.selectedTarget.trackers
        .map((e) => Tracker(EventManager.selectedTarget.id ?? '', type: e.trackType, title: e.title))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          //_selectedTracker == null ? SizedBox() : LineChartWidget(_selectedTracker),
          Expanded(
            child: ListView(
              children: _trackers.map((doc) {
                return GestureDetector(
                  child: TrackerControls(doc),
                  onTap: () => {
                    setState(() {
                      _selectedTracker = doc;
                    }),
                  },
                );
              }).toList(),
            ),
          ),
        ],
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
