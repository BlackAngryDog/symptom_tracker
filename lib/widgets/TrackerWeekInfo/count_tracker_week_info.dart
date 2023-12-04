import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';

import 'abstract_week_info.dart';

class CountTrackerWeekInfo extends AbsWeekInfo {
  final Tracker _tracker;
  final DateTime _trackerDate;

  CountTrackerWeekInfo(this._tracker, this._trackerDate, {Key? key})
      : super(_tracker, _trackerDate, key: key);

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

  @override
  Widget? getDay(int index){
    return Container(
      // add a box decoration with round corners
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        width: 50,
        height: 50,
        alignment: Alignment.center,
        child: Text(widget.currValues[index]));
  }
}
