import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/diet_option.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class DietOptionItem extends StatefulWidget {
  final DietOption item;
  bool selected;

  DietOptionItem(this.selected, this.item, {Key? key}) : super(key: key);

  @override
  State<DietOptionItem> createState() => _DietOptionItemState();
}

class _DietOptionItemState extends State<DietOptionItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.item.title ?? ""),
        trailing: Switch(
          value: widget.selected,
          onChanged: (value) {
            setState(() {
              widget.selected = value;
            });
          },
        ),
      ),
    );
  }
}
