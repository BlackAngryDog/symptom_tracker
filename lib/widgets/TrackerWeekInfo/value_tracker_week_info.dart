import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/abstract_week_info.dart';

class ValueTrackerWeekInfo extends AbsWeekInfo {
  final Tracker _tracker;

  ValueTrackerWeekInfo(this._tracker, _trackerDate, _currValues, {Key? key})
      : super(_tracker, _trackerDate, _currValues, key: key);

  @override
  State<ValueTrackerWeekInfo> createState() => _ValueTrackerWeekInfoState();
}

class _ValueTrackerWeekInfoState
    extends AbsWeekInfoState<ValueTrackerWeekInfo> {
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
  @override
  Widget getDay(int index) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        // add a box decoration with round corners
        decoration: getContainerDecoration(index),
        alignment: Alignment.center,

        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.currValues[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
