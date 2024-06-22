import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';

class AddEvent extends StatefulWidget {

  final Tracker _tracker;
  final DateTime _trackerDate;
  const AddEvent(this._tracker, this._trackerDate, {Key? key}): super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // add note form
    return Card(
      elevation:5,
      child: Column(
        children: [
          const Text('Add Event'),
          const SizedBox(height: 20),

          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),

          const SizedBox(height: 20),

          const Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Note',
                alignLabelWithHint: true,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: add note as datalog

              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}