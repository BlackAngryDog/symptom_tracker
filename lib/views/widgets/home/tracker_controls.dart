import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/enums/tracker_enums.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/popups/add_even_popup.dart';
import 'package:symptom_tracker/popups/add_note_popup.dart';
import 'package:symptom_tracker/popups/diet_options_popup.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/count_tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/diet_tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/quality_tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/rating_tracker.dart';
import 'package:symptom_tracker/views/widgets/home/trackers/value_tracker.dart';

class TrackerControls extends StatefulWidget {
  final Tracker? item;
  final DateTime? date;

  const TrackerControls(this.item, this.date, {Key? key}) : super(key: key);

  @override
  State<TrackerControls> createState() => _TrackerControlsState();
}

class _TrackerControlsState extends State<TrackerControls> {
  Tracker? get _selectedTracker => widget.item ?? EventManager.selectedTracker;
  late StreamSubscription trackerSubscription;

  @override
  void initState() {
    super.initState();

    trackerSubscription = EventManager.stream.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTracker == null) return Container();

    var date = widget.date ?? DateTime.now();

    switch (_selectedTracker!.option.trackType) {
      case TrackerType.note:
        return AddNote(_selectedTracker!,date);
      case TrackerType.event:
        return AddEvent(_selectedTracker!,date);
      case TrackerType.diet:
        return DietOptions(_selectedTracker!,date);
      case TrackerType.counter:
        return getDisplay(CountTracker(_selectedTracker!, date),date);
      case TrackerType.quality:
        return getDisplay(QualityTracker(_selectedTracker!, date),date);
      case TrackerType.rating:
        return getDisplay(RatingTracker(_selectedTracker!, date),date);

      default:
        return getDisplay(ValueTracker(_selectedTracker!, date),date);
    }
  }

  Widget getDisplay(Widget child, DateTime trackDay) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(child: Text(DateTimeExt.formatDate(trackDay))),
            child,
          ],
        ),
      ),
    );
  }
}
