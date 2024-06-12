import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> with SingleTickerProviderStateMixin {
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
          const Text('Add Note'),
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
