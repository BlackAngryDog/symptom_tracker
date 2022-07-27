import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/diet_chart.dart';
import 'package:symptom_tracker/widgets/line_chart.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';

class TrackerInfoPanel extends StatelessWidget {
  final Trackable _selectedTarget;
  final Tracker _selectedTracker;
  const TrackerInfoPanel(this._selectedTarget, this._selectedTracker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.withAlpha(10),
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(_selectedTracker.title ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TrackerItem(_selectedTracker!),
              DietChart(_selectedTarget, _selectedTracker),
            ],
          ),
          LineChartWidget(_selectedTracker),
          TrackerControls(
            _selectedTracker!,
        ],
      ),
    );
  }
}
