import 'package:flutter/material.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/pages/tracker_Summery.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/value_tracker.dart';

class CountTracker extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  const CountTracker(this._tracker, this._trackerDate, {Key? key})
      : super(key: key);

  @override
  State<CountTracker> createState() => _ValueTrackerState();
}

class _ValueTrackerState extends State<CountTracker> {
  int currValue = 0; // TODO - GET TODYS COUNT FOR TRACKER
  String subtitle = 'count today is 0';
  bool _showPad = false;

  @override
  void initState() {
    super.initState();
    getCurrValue();
  }

  void showNumPad() {
    setState(() {
      _showPad = true;
    });
  }

  Future updateData(int v) async {
    currValue += v;
    await widget._tracker.updateLog(currValue, widget._trackerDate);
    //updateValue(currValue);
    EventManager.dispatchUpdate(
        UpdateEvent(EventType.trackerChanged, tracker: widget._tracker));
  }

  Future getCurrValue() async {
    currValue = int.tryParse(
            await widget._tracker.getValue(day: widget._trackerDate)) ??
        0;
    updateValue(currValue);
  }

  void updateValue(int v) {
    setState(() {
      currValue = v;
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
    return _showPad
        ? ValueTracker(widget._tracker, widget._trackerDate)
        :GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(widget._tracker.option.title ?? ""),
          subtitle: Text(subtitle),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              IconButton(
                onPressed: () {
                  if (currValue > 0) {
                    updateData(-1);
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              IconButton(
                onPressed: () {
                  showNumPad();
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                    updateData(1);
                },
                icon: const Icon(Icons.add),
              ),
              /*PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    )
                  ];
                },
                onSelected: (String value) {
                  print('You Click on po up menu item');
                },
              )*/
            ],
          ),
        ),
      ),
      onDoubleTap: () {
        showHistory(context);
      },
    );
  }
}
