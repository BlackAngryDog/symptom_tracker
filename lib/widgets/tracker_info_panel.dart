import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/line_chart.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';

class TrackerInfoPanel extends StatelessWidget {
  final Tracker _selectedTracker;
  const TrackerInfoPanel(this._selectedTracker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Card(
        color: Colors.blueGrey.withAlpha(10),
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LineChartWidget(_selectedTracker),
            TrackerItem(_selectedTracker!),
          ],
        ),
      ),
    );
  }
}
