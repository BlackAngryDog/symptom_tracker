import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:intl/intl.dart';
import 'package:symptom_tracker/model/diet_option.dart';
import 'package:symptom_tracker/model/tracker.dart';

class AddDietOption extends StatefulWidget {
  //const AddTransaction({ Key? key }) : super(key: key);

  final Function(DietOption tracker) onAddItem;

  const AddDietOption(this.onAddItem);

  @override
  State<AddDietOption> createState() => _AddDietOptionState();
}

class _AddDietOptionState extends State<AddDietOption> {
  final titleController = TextEditingController();

  void OnSubmitDate() {
    print("test");
    final String _title = titleController.text;

    if (_title == "") return;

    //Tracker tracker = Tracker('default', title: _title, type: "diet_option");

    widget.onAddItem(DietOption(title: _title));

    Navigator.of(context).pop();
  }

  /*Icon _icon = Icon(Icons.search_outlined);

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.fontAwesomeIcons]);

    _icon = Icon(icon);
    setState(() {});

    debugPrint('Picked Icon:  $icon');
  }
   */

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
            ),
            TextButton(
              onPressed: OnSubmitDate,
              child: Text(
                "Add Option",
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
