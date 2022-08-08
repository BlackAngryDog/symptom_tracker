import 'package:flutter/material.dart';

class TrackerHighlights extends StatefulWidget {
  const TrackerHighlights({Key? key}) : super(key: key);

  @override
  _TrackerHighlightsState createState() => _TrackerHighlightsState();
}

class _TrackerHighlightsState extends State<TrackerHighlights> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('This is where text info can live'),
            ],
          ),
        ),
      ),
    );
  }
}
