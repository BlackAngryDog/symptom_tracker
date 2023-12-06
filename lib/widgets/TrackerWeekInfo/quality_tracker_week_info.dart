import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/abstract_week_info.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';

class QualityTrackerWeekInfo extends AbsWeekInfo {
  final Tracker _tracker;
  final DateTime _trackerDate;

  QualityTrackerWeekInfo(this._tracker, this._trackerDate, {Key? key})
      : super(_tracker, _trackerDate,key: key);

  @override
  State<QualityTrackerWeekInfo> createState() => _QualityTrackerWeekInfoState();
}

class _QualityTrackerWeekInfoState extends AbsWeekInfoState<QualityTrackerWeekInfo> {

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

  @override
  Widget? getDay(int index){
    return Container(
      // add a box decoration with round corners
      decoration: const BoxDecoration(
        color: Colors.white54,
        shape: BoxShape.circle,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: 50,
      height: 50,
      alignment: Alignment.center,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 45,
          ),
          Center(
            child: Text(
              widget.currValues[index],
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
