import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/widgets/tracker_control_list.dart';
import 'package:symptom_tracker/views/widgets/home/tracker_controls.dart';

class TrackerInfoPanel extends StatefulWidget {
  const TrackerInfoPanel({Key? key}) : super(key: key);

  @override
  State<TrackerInfoPanel> createState() => _TrackerInfoPanelState();
}

class _TrackerInfoPanelState extends State<TrackerInfoPanel> {
  Tracker? get _selectedTracker => EventManager.selectedTracker;

  late StreamSubscription trackableSubscription;
  late bool hasData = false;

  @override
  void initState() {
    super.initState();
    checkDataAvailable();
    trackableSubscription = EventManager.stream.listen((event) async {
      checkDataAvailable();
    });
  }

  Future checkDataAvailable() async {
    if (!mounted) {
      return;
    }
    hasData = await _selectedTracker?.getValue() != '';
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    trackableSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 220,
      width: double.infinity,
      child: Card(
        color: Colors.blueGrey.withAlpha(10),
        elevation: 1,
        child: hasData == false
            ? Center(
                child: Column(
                  children: [
                    const Text("No Data"),
                    TrackerControls(null, DateTime.now()),
                  ],
                ),
              )
            : const TrackerControlList(),
        /*Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_selectedTracker == null ? '' : _selectedTracker!.title ?? ''),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const TrackerItem(),
                      AdvTrackerInfo(),
                      DietChart(),
                    ],
                  ),
                  LineChartWidget(),
                  TrackerHighlights(),
                  TrackerControls(),
                ],
              ),
              */
      ),
    );
  }
}
