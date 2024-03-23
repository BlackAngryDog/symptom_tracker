import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/widgets/tracker_item.dart';

class TrackerList extends StatefulWidget {
  final Function(Tracker? tracker) onTrackerSelected;

  const TrackerList(this.onTrackerSelected, {Key? key}) : super(key: key);

  @override
  State<TrackerList> createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerList> {
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
                  child: TrackerItem(doc),
                  onTap: () => {
                    setState(() {
                      _selectedTracker = doc;
                      widget.onTrackerSelected(_selectedTracker);
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
