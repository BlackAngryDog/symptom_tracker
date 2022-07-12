import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:intl/intl.dart';
import 'package:symptom_tracker/model/tracker.dart';

class AddTracker extends StatefulWidget {
  //const AddTransaction({ Key? key }) : super(key: key);

  final Function(Tracker tracker) onAddTracker;

  AddTracker(this.onAddTracker);

  @override
  State<AddTracker> createState() => _AddTrackerState();
}

class _AddTrackerState extends State<AddTracker> {
  final titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String selectedValue = "counter";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("counter"), value: "counter"),
      DropdownMenuItem(child: Text("quality"), value: "quality"),
      DropdownMenuItem(child: Text("value"), value: "value"),
      DropdownMenuItem(child: Text("diet"), value: "diet"),
    ];
    return menuItems;
  }

  void OnSubmitTracker() {
    print("test");
    final String _title = titleController.text;

    if (_title == "") return;

    Tracker tracker = Tracker('default', title: _title, type: selectedValue);

    widget.onAddTracker(tracker);

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

  Icon _icon = Icon(Icons.search_outlined);

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context, iconPackModes: [IconPack.fontAwesomeIcons]);

    _icon = Icon(icon);
    setState(() {});

    debugPrint('Picked Icon:  $icon');
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
            IconButton(onPressed: _pickIcon, icon: _icon),
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            DropdownButton(
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownItems),
            Container(
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
