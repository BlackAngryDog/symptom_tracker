import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/diet_option.dart';

class AddDietOption extends StatefulWidget {
  //const AddTransaction({ Key? key }) : super(key: key);

  final Function(DietOption tracker) onAddItem;

  const AddDietOption(this.onAddItem, {Key? key}) : super(key: key);

  @override
  State<AddDietOption> createState() => _AddDietOptionState();
}

class _AddDietOptionState extends State<AddDietOption> {
  final titleController = TextEditingController();

  void OnSubmitDate() {
    print("test");
    final String title = titleController.text;

    if (title == "") return;

    //Tracker tracker = Tracker('default', title: _title, type: "diet_option");

    widget.onAddItem(DietOption(title: title));

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
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            TextButton(
              onPressed: OnSubmitDate,
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
              child: const Text(
                "Add Option",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
