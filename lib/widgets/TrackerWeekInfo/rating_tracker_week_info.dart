import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/abstract_week_info.dart';

class RatingTrackerWeekInfo extends AbsWeekInfo {
  final Tracker _tracker;
  RatingTrackerWeekInfo(this._tracker, _trackerDate, _currValues, {Key? key})
      : super(_tracker, _trackerDate, _currValues, key: key);

  @override
  State<RatingTrackerWeekInfo> createState() => _RatingTrackerWeekInfoState();
}

class _RatingTrackerWeekInfoState
    extends AbsWeekInfoState<RatingTrackerWeekInfo> {
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

  @override
  Widget getDay(int index) {
    int value = double.tryParse(widget.currValues[index])?.toInt() ?? 0;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        // add a box decoration with round corners
        decoration: getContainerDecoration(index),
        alignment: Alignment.center,

        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: getIcon(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getIcon(int index) {
    switch (index) {
      case 1:
        return const Icon(
          Icons.sentiment_very_dissatisfied,
          color: Colors.red,
        );
      case 2:
        return const Icon(
          Icons.sentiment_dissatisfied,
          color: Colors.redAccent,
        );
      case 3:
        return const Icon(
          Icons.sentiment_neutral,
          color: Colors.amber,
        );
      case 4:
        return const Icon(
          Icons.sentiment_satisfied,
          color: Colors.lightGreen,
        );
      default:
        return const Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.green,
        );
    }
  }
}
