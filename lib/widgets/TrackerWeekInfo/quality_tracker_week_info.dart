import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/abstract_week_info.dart';

class QualityTrackerWeekInfo extends AbsWeekInfo {
  final Tracker _tracker;

  QualityTrackerWeekInfo(this._tracker, _trackerDate, {Key? key})
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
    return AspectRatio(
      aspectRatio: 1,
      
      child: Container(
        // add a box decoration with round corners
        decoration: const BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        alignment: Alignment.center,

        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            const FittedBox(
              child: const Icon(
                Icons.star,
                color: Colors.amber,
                fill: 1,
              ),
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.currValues[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(backgroundColor: Colors.transparent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
