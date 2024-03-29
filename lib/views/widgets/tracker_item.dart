import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/widgets/mini_trackers/count_tracker.dart';

class TrackerItem extends StatelessWidget {
  final Tracker item;

  const TrackerItem(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (item.option.trackType) {
      case "counter":
        return MiniCountTracker(item);
      case "quality":
        return MiniCountTracker(item);
      case "diet":
        return MiniCountTracker(item);
      default:
        return MiniCountTracker(item);
    }
  }
}
