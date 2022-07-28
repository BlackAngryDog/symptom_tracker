import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/widgets/mini_trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/diet_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class TrackerControls extends StatefulWidget {
  TrackerControls({Key? key}) : super(key: key);

  @override
  State<TrackerControls> createState() => _TrackerControlsState();
}

class _TrackerControlsState extends State<TrackerControls> {
  Tracker? _selectedTracker;
  late StreamSubscription trackerSubscription;

  @override
  void initState() {
    super.initState();

    TrackerPage.trackerController.stream.listen((event) {
      setState(() {
        _selectedTracker = event;
      });
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
        return CountTracker(_selectedTracker!);
      case "quality":
        return QualityTracker(_selectedTracker!);
      case "diet":
        return DietTracker(_selectedTracker!);
      default:
        return ValueTracker(_selectedTracker!);
    }
  }
}
