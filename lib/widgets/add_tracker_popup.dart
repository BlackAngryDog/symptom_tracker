import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';

import '../model/track_option.dart';

class AddTracker extends StatefulWidget {
  //const AddTransaction({ Key? key }) : super(key: key);

  final Tracker? tracker;
  final Function(TrackOption option) onAddTracker;

  const AddTracker(this.onAddTracker, {Key? key, this.tracker})
      : super(key: key);

  @override
  State<AddTracker> createState() => _AddTrackerState();
}

class _AddTrackerState extends State<AddTracker> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();

  String selectedValue = "counter";
  String? selectedIcon = "favorite";

  late TrackOption option;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "counter",
        child: Text("counter"),
      ),
      const DropdownMenuItem(
        value: "quality",
        child: Text("quality"),
      ),
      const DropdownMenuItem(
        value: "rating",
        child: Text("satisfaction"),
      ),
      const DropdownMenuItem(
        value: "value",
        child: Text("value"),
      ),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<AutoFill>> get autofillItems {
    return AutoFill.values
        .map((e) => DropdownMenuItem<AutoFill>(
            value: e, child: Text(e.toShortString())))
        .toList();
  }

  void OnSubmitTracker() {
    print("test");
    final String title = titleController.text;

    //final String value = valueController.text;

    if (title == '') return;

    option.save();
    widget.onAddTracker(option);
    // ADD STARTING VALUE;
    // var tracker =
    //     Tracker.fromTrackOption(EventManager.selectedTarget.id ?? '', option);
    // tracker.updateLog(value, DateTime.now());

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
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            valueController.text = rating.toString();
          },
        ); // ADD BASELINE VALUE (as 1-X picker)
      default:
        return TextField(
          decoration: const InputDecoration(labelText: 'Current Value'),
          controller: valueController,
          textAlign: TextAlign.end,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.tracker?.option.title ?? '';
    selectedValue = widget.tracker?.option.trackType ?? 'counter';
    selectedIcon = widget.tracker?.option.icon ?? 'favorite';

    option = widget.tracker?.option ??
        TrackOption(
            title: titleController.text,
            trackType: selectedValue,
            icon: selectedIcon);

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
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
              textAlign: TextAlign.end,
              onChanged: (value) {
                option.title = value;
              },
            ),
            DropdownButton(
                value: option.trackType,
                onChanged: (String? newValue) {
                  setState(() {
                    option.trackType = newValue!;
                  });
                },
                items: dropdownItems),
            DropdownButton(
                value: option.autoFill,
                onChanged: (AutoFill? newValue) {
                  setState(() {
                    option.autoFill = newValue!;
                  });
                },
                items: autofillItems),
            //getControl(context),

            // TODO - need an icon for quality and ratings - do we need one for tracker ?

            IconPicker(
              initialValue: 'favorite',
              icon: const Icon(Icons.apps),
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
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
              child: const Text(
                "Add Transaction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
