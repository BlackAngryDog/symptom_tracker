import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/count_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/diet_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/quality_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/rating_tracker_week_info.dart';
import 'package:symptom_tracker/widgets/TrackerWeekInfo/value_tracker_week_info.dart';

import 'add_tracker_popup.dart';

class TrackerWeekInfo extends StatefulWidget {
  final Tracker? item;
  final DateTime? date;

  const TrackerWeekInfo(this.item, this.date, {Key? key}) : super(key: key);

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

    return GestureDetector(
      onTap: () {
        _editTrackerPopup(context);
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getDisplay(),
        ),
      ),
    );
  }

  void _editTrackerPopup(BuildContext ctx) {
    if (_selectedTracker == null) return;

    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child:
                AddTracker((option) {}, tracker: _selectedTracker as Tracker),
          );
        });
  }

  StatefulWidget getDisplay() {
    switch (_selectedTracker!.option.trackType) {
      case "counter":
        return CountTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
      case "quality":
        return QualityTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
      case "rating":
        return RatingTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
      case "diet":
        return DietTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
      default:
        return ValueTrackerWeekInfo(
            _selectedTracker!, widget.date ?? DateTime.now());
    }
  }
}
