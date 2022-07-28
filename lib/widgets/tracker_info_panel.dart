import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/widgets/diet_chart.dart';
import 'package:symptom_tracker/widgets/line_chart.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';

class TrackerInfoPanel extends StatefulWidget {
  const TrackerInfoPanel({Key? key}) : super(key: key);

  @override
  State<TrackerInfoPanel> createState() => _TrackerInfoPanelState();
}

class _TrackerInfoPanelState extends State<TrackerInfoPanel> {
  Trackable? _selectedTarget;
  Tracker? _selectedTracker;

  late StreamSubscription trackableSubscription;

  @override
  void initState() {
    super.initState();
    trackableSubscription = EventManager.stream.listen((event) {
      setState(() {
        _selectedTarget = EventManager.selectedTarget;
        _selectedTracker = EventManager.selectedTracker;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackableSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.withAlpha(10),
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(_selectedTracker == null ? '' : _selectedTracker!.title ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // const TrackerItem(),
              Container(
                width: 100,
                height: 100,
                color: Colors.tealAccent,
              ),
              DietChart(),
            ],
          ),
          LineChartWidget(),
          TrackerControls(),
        ],
      ),
    );
  }
}
