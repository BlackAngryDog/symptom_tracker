import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';

import '../model/track_option.dart';

class AddTracker extends StatefulWidget {
  //const AddTransaction({ Key? key }) : super(key: key);

  final Function(TrackOption option) onAddTracker;

  AddTracker(this.onAddTracker);

  @override
  State<AddTracker> createState() => _AddTrackerState();
}

class _AddTrackerState extends State<AddTracker> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();

  String selectedValue = "counter";
  String? selectedIcon = "favorite";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "counter", child: Text("counter"), ),
      const DropdownMenuItem(value: "quality", child: Text("quality"), ),
      const DropdownMenuItem(value: "rating", child: Text("satisfaction"), ),
      const DropdownMenuItem(value: "value", child: Text("value"), ),
    ];
    return menuItems;
  }

  void OnSubmitTracker() {
    print("test");
    final String _title = titleController.text;

    final String _value = valueController.text;

    if (_title == '' || _value == '') return;

    TrackOption option = TrackOption(
        title: _title, trackType: selectedValue, icon: selectedIcon);
    option.save();
    widget.onAddTracker(option);
    // ADD STARTING VALUE;
    Tracker.fromTrackOption(EventManager.selectedTarget.id ?? '', option)
        .updateLog(_value, DateTime.now());

    Navigator.of(context).pop();
  }

  Widget getControl(BuildContext context) {

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
    final Map<String, IconData> myIconCollection = {
      'favorite': Icons.favorite,
      'home': Icons.home,
      'android': Icons.android,
      'album': Icons.album,
      'ac_unit': Icons.ac_unit,
    };

    // TODO - This flow needs a better screen + need to get default or ask for initial value

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

            // TODO - need an icon for quality and ratings - do we need one for tracker ?

            IconPicker(
              initialValue: 'favorite',
              icon: Icon(Icons.apps),
              labelText: "Icon",
              title: "Select an icon",
              cancelBtn: "CANCEL",
              enableSearch: true,
              searchHint: 'Search icon',
              iconCollection: myIconCollection,
              onChanged: (val) => {selectedIcon = val},
              onSaved: (val) => {selectedIcon = val},
            ),

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
