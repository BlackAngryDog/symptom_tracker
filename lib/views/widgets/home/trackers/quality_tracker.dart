import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/pages/tracker_Summery.dart';

class QualityTracker extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  const QualityTracker(this._tracker, this._trackerDate, {Key? key})
      : super(key: key);

  @override
  State<QualityTracker> createState() => _QualityTrackerState();
}

class _QualityTrackerState extends State<QualityTracker> {
  double currValue = 0; // TODO - GET TODAY'S COUNT FOR TRACKER
  String subtitle = 'value is today is 0';

  @override
  void initState() {
    super.initState();
    getCurrValue();
  }

  Future updateData(double value) async {
    await widget._tracker.updateLog(value, widget._trackerDate);
    getCurrValue();
    EventManager.dispatchUpdate(
        UpdateEvent(EventType.trackerChanged, tracker: widget._tracker));

  }

  Future getCurrValue() async {
    currValue = double.tryParse(
            await widget._tracker.getValue(day: widget._trackerDate)) ??
        0;

    setState(() {
      subtitle = 'today is $currValue';
    });
  }

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
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        title: Text(widget._tracker.option.title ?? ""),
        subtitle: Text(subtitle),
        trailing: RatingBar.builder(
          initialRating: currValue,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,

          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            updateData(rating);
          },
        ),
      ),
      onDoubleTap: () {
        showHistory(context);
      },
    );
  }
}
