import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_info.dart';

class QualityTracker extends StatefulWidget {
  final Tracker _tracker;
  const QualityTracker(this._tracker, {Key? key}) : super(key: key);

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
    await widget._tracker.updateLog(value);
    getCurrValue();
  }

  Future getCurrValue() async {
    DataLog? log = await widget._tracker.getLastEntry(true);
    currValue = log!.value;
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
      child: Card(
        child: ListTile(
          title: Text(widget._tracker.title ?? ""),
          subtitle: Text(subtitle),
          trailing: RatingBar.builder(
            initialRating: currValue,
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
      ),
      onTap: () {
        showHistory(context);
      },
    );
  }
}
