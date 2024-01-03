import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';

class TrackerSummeryPage extends StatelessWidget {
  final Tracker _tracker;
  const TrackerSummeryPage(this._tracker, {Key? key}) : super(key: key);

  Widget getState() {
    print('tracker type is ${_tracker.option.trackType}');
    switch (_tracker.option.trackType) {
      case "counter":
        return CountTrackerInfo(_tracker);
      case "quality":
        return QualityTrackerInfo(_tracker);
      case "diet":
        return DietTrackerInfo(_tracker);
      default:
        return ValueTrackerInfo(_tracker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('history'),
      ),
      body: TrackerDietSummary(_tracker),
    );
  }
}

class TrackerDietSummary extends StatelessWidget {
  final Tracker _tracker;
  const TrackerDietSummary(this._tracker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Summery of ${_tracker.option.title}'),
        TrackerDietSummaryItem('Beef', 2, 3, 6, 10),
        TrackerDietSummaryItem('Venision', 5, 6, 7, 10),
        // LineChartWidget(_tracker),
      ],
    );
  }
}

class TrackerDietSummaryItem extends StatelessWidget {
  final String title;
  final double min;
  final double max;
  final double advarage;
  final double total;

  const TrackerDietSummaryItem(
      this.title, this.min, this.advarage, this.max, this.total,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).copyWith().size.width - 16;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summery of ${title}'),
          Container(
            height: 30,
            width: width,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.blueGrey,
                    Colors.blueGrey,
                    Colors.blue,
                    Colors.blueAccent,
                    Colors.black,
                    Colors.blueAccent,
                    Colors.blue,
                    Colors.blueGrey,
                    Colors.blueGrey,
                  ],
                  stops: <double>[
                    0,
                    min / total,
                    min / total,
                    (advarage - 0.05) / total,
                    (advarage) / total,
                    (advarage + 0.05) / total,
                    max / total,
                    max / total,
                    1
                  ],
                ),
              ),
            ),
          ),

          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: (min).round(),
                  child: Text(
                    'min:${min}',
                    textAlign: TextAlign.end,
                  ),
                ),
                Expanded(
                  flex: (max - min).round(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      'adv:${advarage}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                    flex: (((total - max) / total) * 10).round(),
                    child: Text(
                      'max:${max}',
                      textAlign: TextAlign.start,
                    )),
              ],
            ),
          ),
          // LineChartWidget(_tracker),
        ],
      ),
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
        Text('Summery of ${_tracker.option.title}'),
        //LineChartWidget(_tracker),
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
        Text('Summery of ${_tracker.option.title}'),
        //LineChartWidget(_tracker),
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
        Text('Summery of ${_tracker.option.title}'),
        // LineChartWidget(_tracker),
      ],
    );
  }
}

class DietTrackerInfo extends StatelessWidget {
  final Tracker _tracker;
  const DietTrackerInfo(this._tracker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Summery of ${_tracker.option.title}'),
        // LineChartWidget(_tracker),
      ],
    );
  }
}
