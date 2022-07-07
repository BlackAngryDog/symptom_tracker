import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';

class QualityTracker extends StatefulWidget {
  final Tracker _tracker;
  const QualityTracker(this._tracker, {Key? key}) : super(key: key);

  @override
  State<QualityTracker> createState() => _QualityTrackerState();
}

class _QualityTrackerState extends State<QualityTracker> {
  double currValue = 0; // TODO - GET TODYS COUNT FOR TRACKER
  String subtitle = 'calue is today is 0';

  void updateData(double value) {
    // save data log entry,

    currValue = value;
    widget._tracker.updateLog(value);
    setState(() {
      subtitle = 'today is $currValue';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget._tracker.title ?? ""),
        subtitle: Text(subtitle),
        trailing: RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            updateData(rating);
          },
        ),
      ),
    );
  }
}
