import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/count_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/diet_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/quality_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/rating_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/value_tracker_week_info.dart';


class TrackerWeekInfo extends StatefulWidget {
  final Tracker item;
  final DateTime date;
  final List<String> data;

  const TrackerWeekInfo(this.item, this.date, this.data, {Key? key}) : super(key: key);

  @override
  State<TrackerWeekInfo> createState() => _TrackerWeekInfoState();
}

class _TrackerWeekInfoState extends State<TrackerWeekInfo> {
  Tracker? get _selectedTracker => widget.item ?? EventManager.selectedTracker;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTracker == null) return Container();

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getDisplay(),
      ),
    );
  }

  StatefulWidget getDisplay() {
    switch (_selectedTracker!.option.trackType) {
      case "counter":
        return CountTrackerWeekInfo(
            _selectedTracker!, widget.date, widget.data);
      case "quality":
        return QualityTrackerWeekInfo(
            _selectedTracker!, widget.date, widget.data);
      case "rating":
        return RatingTrackerWeekInfo(
            _selectedTracker!, widget.date, widget.data);
      case "diet":
        return DietTrackerWeekInfo(
            _selectedTracker!, widget.date);
      default:
      // TODO - ADD Duration - like value but with time
      // TODO - Add SEVERITY like quality but with a scale
        return ValueTrackerWeekInfo(
            _selectedTracker!, widget.date, widget.data);
    }
  }
}
