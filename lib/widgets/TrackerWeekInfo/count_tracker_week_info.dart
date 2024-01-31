import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';

import 'abstract_week_info.dart';

class CountTrackerWeekInfo extends AbsWeekInfo {
  final Tracker _tracker;

  CountTrackerWeekInfo(this._tracker, _trackerDate, _currValues, {Key? key})
      : super(_tracker, _trackerDate, _currValues, key: key);

  @override
  State<CountTrackerWeekInfo> createState() => _ValueTrackerState();
}

class _ValueTrackerState extends AbsWeekInfoState<CountTrackerWeekInfo> {
  void showHistory(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => TrackerSummeryPage(
          widget._tracker,
        ),
      ),
    );
  }
}
