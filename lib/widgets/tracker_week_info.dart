import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/count_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/diet_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/quality_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/rating_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/value_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/bottom_tracker_panel.dart';
import 'package:symptom_tracker/widgets/mini_trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTracker == null) return Container();

    IconData? icon;
    if (_selectedTracker?.icon != null) {
      var iconDataJson = jsonDecode(_selectedTracker?.icon??"");
      icon = IconData(
          iconDataJson['codePoint'],
          fontFamily: iconDataJson['fontFamily']);
    }

    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,

      child:getDisplay(),
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
      case "rating":
        return RatingTrackerWeekInfo(
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
