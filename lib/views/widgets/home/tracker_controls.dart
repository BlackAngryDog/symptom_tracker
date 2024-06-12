import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/enums/tracker_enums.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/count_tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/diet_tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/quality_tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/rating_tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/value_tracker.dart';

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

    switch (_selectedTracker!.option.trackType) {
      case TrackerType.counter:
        return CountTracker(_selectedTracker!, widget.date ?? DateTime.now());
      case TrackerType.quality:
        return QualityTracker(_selectedTracker!, widget.date ?? DateTime.now());
      case TrackerType.rating:
        return RatingTracker(_selectedTracker!, widget.date ?? DateTime.now());
      case TrackerType.diet:
        return DietTracker(_selectedTracker!);
      default:
        return ValueTracker(_selectedTracker!, widget.date ?? DateTime.now());
    }
  }
}
