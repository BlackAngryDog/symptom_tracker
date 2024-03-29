import 'package:flutter/material.dart';
import 'package:symptom_tracker/views/widgets/tracker_button_grid.dart';

class BottomTrackerSelectionPanel extends StatefulWidget {
  const BottomTrackerSelectionPanel({Key? key}) : super(key: key);

  @override
  State<BottomTrackerSelectionPanel> createState() => _BottomTrackerSelectionPanelState();
}

class _BottomTrackerSelectionPanelState extends State<BottomTrackerSelectionPanel> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        return const Card(
          color: Colors.orange,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: TrackerButtonGrid(),
              )
            ],
          ),
        );
      },
    );
  }
}
