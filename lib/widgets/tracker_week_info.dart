import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/count_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/diet_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/quality_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/value_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/mini_trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/diet_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class TrackerWeekInfo extends StatefulWidget {
  final Tracker? item;
  final DateTime? date;

  const TrackerWeekInfo(this.item, this.date, {Key? key}) : super(key: key);

  @override
  State<TrackerWeekInfo> createState() => _TrackerWeekInfoState();
}

class _TrackerWeekInfoState extends State<TrackerWeekInfo> {
  Tracker? get _selectedTracker => widget.item ?? EventManager.selectedTracker;
  late StreamSubscription trackerSubscription;

  @override
  void initState() {
    super.initState();

    trackerSubscription = EventManager.stream.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTracker == null) return Container();

    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedTracker?.title ?? "",
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 24),
          ),
          getDisplay(),
        ],
      ),
    );

    switch (_selectedTracker!.type) {
      case "counter":
        return CountTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
      case "quality":
        return QualityTracker(_selectedTracker!, widget.date ?? DateTime.now());
      case "diet":
        return DietTracker(_selectedTracker!, widget.date ?? DateTime.now());
      default:
        return ValueTracker(_selectedTracker!, widget.date ?? DateTime.now());
    }
  }

  StatefulWidget getDisplay() {
    switch (_selectedTracker!.type) {
      case "counter":
        return CountTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
      case "quality":
        return QualityTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
      case "diet":
        return DietTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
      default:
        return ValueTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
    }
  }
}
