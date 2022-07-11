import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/line_chart.dart';

class TrackerSummeryPage extends StatelessWidget {
  final Tracker _tracker;
  const TrackerSummeryPage(this._tracker, {Key? key}) : super(key: key);

  Widget getState() {
    print('tracker type is ${_tracker.type}');
    switch (_tracker.type) {
      case "counter":
        return CountTrackerInfo(_tracker);
      case "quality":
        return QualityTrackerInfo(_tracker);
      default:
        return ValueTrackerInfo(_tracker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('history'),
      ),
      body: getState(),
    );
  }
}

class CountTrackerInfo extends StatelessWidget {
  final Tracker _tracker;
  const CountTrackerInfo(this._tracker, {Key? key}) : super(key: key);

  // CHART PROGRESSION OF VALUE PER DAY

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LineChart(_tracker),
      ],
    );
  }
}

class QualityTrackerInfo extends StatelessWidget {
  final Tracker _tracker;
  const QualityTrackerInfo(this._tracker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Summery of ${_tracker.title}'),
        LineChart(_tracker),
      ],
    );
  }
}

class ValueTrackerInfo extends StatelessWidget {
  final Tracker _tracker;
  const ValueTrackerInfo(this._tracker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LineChart(_tracker),
      ],
    );
  }
}
