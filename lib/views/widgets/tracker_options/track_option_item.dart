import 'package:flutter/material.dart';

class TrackOptionItem<T> extends StatefulWidget {
  final T item;
  bool selected;
  int order = 1000000;

  TrackOptionItem(this.selected, this.item, {Key? key}) : super(key: key);

  @override
  State<TrackOptionItem> createState() => _TrackOptionItemState();
}

class _TrackOptionItemState extends State<TrackOptionItem> {
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
