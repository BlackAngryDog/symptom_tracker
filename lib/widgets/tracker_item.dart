import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/mini_trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/diet_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class TrackerItem extends StatelessWidget {
  final Tracker item;
  bool? useMini = true;

  TrackerItem(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case "counter":
        return useMini == true ? MiniCountTracker(item) : CountTracker(item);
      case "quality":
        return useMini == true ? MiniCountTracker(item) : QualityTracker(item);
      case "diet":
        return useMini == true ? MiniCountTracker(item) : DietTracker(item);
      default:
        return useMini == true ? MiniCountTracker(item) : ValueTracker(item);
    }
  }
}
