import 'package:flutter/material.dart';

class DietOptionItem<T> extends StatefulWidget {
  final T item;
  bool selected;
  int order = 1000000;

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
