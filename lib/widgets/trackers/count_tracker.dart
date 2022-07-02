import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';

class CountTracker extends StatefulWidget {
  final Tracker _tracker;
  const CountTracker(this._tracker, {Key? key}) : super(key: key);

  @override
  State<CountTracker> createState() => _ValueTrackerState();
}

class _ValueTrackerState extends State<CountTracker> {
  int currValue = 0; // TODO - GET TODYS COUNT FOR TRACKER
  String subtitle = 'count today is 0';

  void updateData() {
    currValue++;
    DataLog log = DataLog(widget._tracker.trackableID, DateTime.now(),
        title: 'log ${widget._tracker}',
        type: widget._tracker.type,
        value: currValue);
    setState(() {
      subtitle = 'count today is $currValue';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget._tracker.title ?? ""),
        subtitle: Text(subtitle),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    updateData();
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
        ),
      ),
    );
  }
}
