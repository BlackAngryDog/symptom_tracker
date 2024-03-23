import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/widgets/home/tracker_controls.dart';

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
    _trackers = EventManager.selectedTarget.getTrackers();
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
                  child: TrackerControls(doc, DateTime.now()),
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
    );
  }
}
