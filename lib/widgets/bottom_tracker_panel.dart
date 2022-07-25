import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/tracker_list.dart';

class BottomTrackerSelectionPanel extends StatefulWidget {
  final Trackable _trackable;
  final Function(Tracker? tracker) onTrackerSelected;
  const BottomTrackerSelectionPanel(this._trackable, this.onTrackerSelected, {Key? key}) : super(key: key);

  @override
  State<BottomTrackerSelectionPanel> createState() => _BottomTrackerSelectionPanelState();
}

class _BottomTrackerSelectionPanelState extends State<BottomTrackerSelectionPanel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200,
        child: TrackerList(widget._trackable, (tracker) {
          widget.onTrackerSelected(tracker);
        }),
      ),
    );
  }
}
