import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';

class AdvTrackerInfo extends StatefulWidget {
  const AdvTrackerInfo({Key? key}) : super(key: key);

  @override
  State<AdvTrackerInfo> createState() => _AdvTrackerInfoState();
}

class _AdvTrackerInfoState extends State<AdvTrackerInfo> {
  Tracker? get _selectedTracker => EventManager.selectedTracker;
  late StreamSubscription trackerSubscription;
  String _currValue = '';

  @override
  void initState() {
    super.initState();
    getCurrValue();
    trackerSubscription = EventManager.stream.listen((event) {
      if (_selectedTracker != null) getCurrValue();
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  Future getCurrValue() async {
    List<dynamic> values = await _selectedTracker!.getValuesFor(DateTimeExt.lastWeek, DateTime.now());

    if (values.isEmpty) return _currValue = '0';

    double total = 0;
    for (dynamic v in values) {
      double curr = double.tryParse(v.toString()) ?? 0;
      total += curr;
    }

    setState(() {
      _currValue = (total / values.length).toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Card(
        color: Colors.lime,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('ADV'),
            Text(_currValue),
          ],
        ),
      ),
    );
  }
}
