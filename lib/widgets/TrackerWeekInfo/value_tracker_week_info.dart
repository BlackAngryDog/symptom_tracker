import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/abstract_week_info.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';

class ValueTrackerWeekInfo extends AbsWeekInfo {
  final Tracker _tracker;
  final DateTime _trackerDate;

  ValueTrackerWeekInfo(this._tracker, this._trackerDate, {Key? key})
      : super(_tracker, _trackerDate, key: key);

  @override
  State<ValueTrackerWeekInfo> createState() => _ValueTrackerWeekInfoState();
}

class _ValueTrackerWeekInfoState extends AbsWeekInfoState<ValueTrackerWeekInfo> {

  String subtitle = 'count today is 0';

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

  // TODO - Show trends in this area

  @override
  Widget? getDay(int index){
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
                // add a box decoration with round corners
                decoration: const BoxDecoration(
                  color: Colors.white54,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(50)),

                ),

                alignment: Alignment.center,

                child: Text(widget.currValues[index])),
    );
  }
}
