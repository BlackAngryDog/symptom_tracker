import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/mini_trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/diet_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class TrackerControls extends StatelessWidget {
  final Tracker item;

  TrackerControls(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case "counter":
        return CountTracker(item);
      case "quality":
        return QualityTracker(item);
      case "diet":
        return DietTracker(item);
      default:
        return ValueTracker(item);
    }
  }
}
