import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/count_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/mini_trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/diet_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class TrackerControls extends StatefulWidget {
  final Tracker? item;
  final DateTime? date;

  const TrackerControls(this.item, this.date, {Key? key}) : super(key: key);

  @override
  State<TrackerControls> createState() => _TrackerControlsState();
}

class _TrackerControlsState extends State<TrackerControls> {
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

    switch (_selectedTracker!.type) {
      case "counter":
        return CountTracker(_selectedTracker!, widget.date ?? DateTime.now());
      case "quality":
        return QualityTracker(_selectedTracker!, widget.date ?? DateTime.now());
      case "diet":
        return DietTracker(_selectedTracker!, widget.date ?? DateTime.now());
      default:
        return ValueTracker(_selectedTracker!, widget.date ?? DateTime.now());
    }
  }
}
