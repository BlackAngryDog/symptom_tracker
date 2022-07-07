import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';

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

  int currValue = 0; // TODO - GET TODYS COUNT FOR TRACKER
  String subtitle = 'calue is today is 0';

  void updateData(String value) {
    // should data be consolidated each day?

    currValue = int.parse(value);
    widget._tracker.updateLog(value);

    //DataLog log = DataLog(widget._tracker.trackableID, DateTime.now(), title: 'log ${widget._tracker.title}', type: widget._tracker.type, value: currValue);
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
        trailing: SizedBox(
            width: 100,
            child: TextField(
              decoration: const InputDecoration(
                  labelText: 'Update',
                  hintText: 'Hint',
                  icon: Icon(Icons.people)),
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
    );
  }
}
