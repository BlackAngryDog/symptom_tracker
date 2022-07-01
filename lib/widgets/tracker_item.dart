import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class TrackerItem extends StatelessWidget {
  final Tracker item;

  const TrackerItem(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case "counter":
        return CountTracker(item);
      case "quality":
        return QualityTracker(item);
      default:
        return ValueTracker(item);
    }
  }
}
