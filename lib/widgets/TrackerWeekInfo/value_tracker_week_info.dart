import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/abstract_week_info.dart';

class ValueTrackerWeekInfo extends AbsWeekInfo {
  final Tracker _tracker;

  ValueTrackerWeekInfo(this._tracker, _trackerDate, {Key? key})
      : super(_tracker, _trackerDate, key: key);

  @override
  State<ValueTrackerWeekInfo> createState() => _ValueTrackerWeekInfoState();
}

class _ValueTrackerWeekInfoState extends AbsWeekInfoState<ValueTrackerWeekInfo> {

  @override
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

}
