import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/diet_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class AddTracker extends StatefulWidget {
  //const AddTransaction({ Key? key }) : super(key: key);

  final Function(Tracker tracker) onAddTracker;

  AddTracker(this.onAddTracker);

  @override
  State<AddTracker> createState() => _AddTrackerState();
}

class _AddTrackerState extends State<AddTracker> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String selectedValue = "counter";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("counter"), value: "counter"),
      DropdownMenuItem(child: Text("quality"), value: "quality"),
      DropdownMenuItem(child: Text("value"), value: "value"),
    ];
    return menuItems;
  }

  void OnSubmitTracker() {
    print("test");
    final String _title = titleController.text;

    final String _value = valueController.text;

    if (_title == '' || _value == '') return;

    Tracker tracker = Tracker(EventManager.selectedTarget.id ?? '', title: _title, type: selectedValue);

    widget.onAddTracker(tracker);
    // ADD STARTING VALUE;
    tracker.updateLog(_value);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((value) => {
          setState(() {
            _selectedDate = value ?? DateTime.now();
          })
        });
  }

  Widget getControl(BuildContext context) {
    Tracker temp = Tracker('', type: selectedValue);
    switch (selectedValue) {
      case "counter":
      // ADD BASELINE VALUE (textfield)
      case "quality":
        return RatingBar.builder(
          initialRating: 0,
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
            valueController.text = rating.toString();
          },
        ); // ADD BASELINE VALUE (as 1-X picker)
      default:
        return TextField(
          decoration: InputDecoration(labelText: 'Current Value'),
          controller: valueController,
          textAlign: TextAlign.end,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              textAlign: TextAlign.end,
            ),
            DropdownButton(
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownItems),
            getControl(context),
            /*Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(DateFormat.yMMMd().format(_selectedDate)),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      "Choose Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(primary: Colors.purple),
                  )
                ],
              ),
            ),

             */
            TextButton(
              onPressed: OnSubmitTracker,
              child: Text(
                "Add Transaction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(primary: Colors.purple),
            )
          ],
        ),
      ),
    );
  }
}
