import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';

class RatingTracker extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  const RatingTracker(this._tracker, this._trackerDate, {Key? key})
      : super(key: key);

  @override
  State<RatingTracker> createState() => _RatingTrackerState();
}

class _RatingTrackerState extends State<RatingTracker> {
  double currValue = 0; // TODO - GET TODAY'S COUNT FOR TRACKER
  String subtitle = 'value is today is 0';

  @override
  void initState() {
    super.initState();
    getCurrValue();
  }

  Future updateData(double value) async {
    await widget._tracker.updateLog(value, widget._trackerDate);
    EventManager.dispatchUpdate(
        UpdateEvent(EventType.trackerChanged, tracker: widget._tracker));
    getCurrValue();
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
      child: Card(
        child: ListTile(
          title: Text(widget._tracker.option.title ?? ""),
          subtitle: Text(subtitle),
          trailing: RatingBar.builder(
            initialRating: currValue,
            itemCount: 5,
            minRating: 1,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  );
                case 1:
                  return const Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.redAccent,
                  );
                case 2:
                  return const Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  );
                case 3:
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
            },
            onRatingUpdate: (rating) {
              updateData(rating);
            },
          ),
        ),
      ),
      onDoubleTap: () {
        showHistory(context);
      },
    );
  }
}
