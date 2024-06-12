import 'package:flutter/material.dart';
import 'package:symptom_tracker/enums/tracker_enums.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/widgets/mini_trackers/count_tracker.dart';

class TrackerItem extends StatelessWidget {
  final Tracker item;

  const TrackerItem(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (item.option.trackType) {
      case TrackerType.counter:
        return MiniCountTracker(item);
      case TrackerType.quality:
        return MiniCountTracker(item);
      case TrackerType.diet:
        return MiniCountTracker(item);
      default:
        return MiniCountTracker(item);
    }
  }
}
