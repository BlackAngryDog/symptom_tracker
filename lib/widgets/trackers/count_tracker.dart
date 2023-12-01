import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';

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

  @override
  void initState() {
    super.initState();
    getCurrValue();
  }

  Future updateData() async {
    currValue++;

    await widget._tracker
        .updateLog(currValue, widget._trackerDate ?? DateTime.now());
    print('val');
    EventManager.dispatchUpdate(UpdateEvent(EventType.trackerChanged, tracker: widget._tracker));
    getCurrValue();
  }

  Future getCurrValue() async {
    currValue = int.tryParse(
            await widget._tracker.getLastValueFor(widget._trackerDate, includePrevious: false)) ??
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
          title: Text(widget._tracker.title ?? ""),
          subtitle: Text(subtitle),
          trailing: SizedBox(
            width: 100,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    updateData();
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
      ),
      onDoubleTap: () {
        showHistory(context);
      },
    );
  }
}
