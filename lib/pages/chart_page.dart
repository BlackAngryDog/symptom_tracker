import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/widgets/diet_chart.dart';
import 'package:symptom_tracker/widgets/line_chart_new.dart';
import 'package:symptom_tracker/widgets/tracker_info_widgets/value_tracker_info.dart';

class ChartPage extends StatefulWidget {
  // TODO - Add a away to show just one tracker from load
  final Trackable trackable;
  const ChartPage(this.trackable, {Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<DataLog> roseData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('history'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).copyWith().size.height,
          child: Column(
            children: [
              Expanded(
                  child: Row(
                children: [
                  //TODO - create a weight details widget - make weight a default tracker
                  Expanded(
                    child: ValueTrackerDisplay(
                      EventManager.selectedTarget.getWeightTracker(),
                      DateTime.now().subtract(const Duration(days: 90)),
                      DateTime.now(),
                    ),
                  ),

                  Expanded(child: DietChart()),
                ],
              )),
              const Expanded(child: LineDataChart()),
            ],
          ),
        ),
      ),
    );
  }
}
