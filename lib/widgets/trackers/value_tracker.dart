import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';

class ValueTracker extends StatefulWidget {
  final Tracker _tracker;
  const ValueTracker(this._tracker, {Key? key}) : super(key: key);

  @override
  State<ValueTracker> createState() => _ValueTrackerState();
}

class _ValueTrackerState extends State<ValueTracker> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
    getCurrValue();
  }

  void _printLatestValue() {
    myController.text = "test";
    print('Second text field: ${myController.text}');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  String currValue = ''; // TODO - GET TODYS COUNT FOR TRACKER
  String subtitle = 'value is today is 0';
  IconData icon = Icons.arrow_right;

  Future updateData(String value) async {
    await widget._tracker.updateLog(value);
    EventManager.dispatchUpdate();
    getCurrValue();
  }

  Future getCurrValue() async {
    double curr = double.tryParse(await widget._tracker.getLastValue(false)) ?? 0;
    double last = double.tryParse(await widget._tracker.getLastValueFor(DateTime.now().add(const Duration(days: -1)))) ?? 0;

    // GET TREND ICON
    icon = Icons.arrow_right;
    if (curr > last) {
      icon = Icons.arrow_drop_up;
    } else if (curr < last) {
      icon = Icons.arrow_drop_down;
    }
    currValue = curr.toString();
    print('last ${last} , curr ${curr}');
    setState(() {
      subtitle = currValue.toString();
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
          subtitle: Row(
            children: [
              Icon(icon),
              Text(subtitle),
            ],
          ),
          trailing: SizedBox(
              width: 100,
              child: TextField(
                decoration: const InputDecoration(labelText: 'Update', hintText: 'Hint', icon: Icon(Icons.people)),
                autocorrect: true,
                autofocus: false,
                //displaying number keyboard
                //keyboardType: TextInputType.number,

                //displaying text keyboard
                keyboardType: TextInputType.number,

                //onChanged: _onChanged,
                onSubmitted: updateData,
              )),
        ),
      ),
      onDoubleTap: () {
        showHistory(context);
      },
    );
  }
}
