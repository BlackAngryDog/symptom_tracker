import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/database_objects/data_log.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';
import 'package:symptom_tracker/views/widgets/history/diet_chart.dart';
import 'package:symptom_tracker/views/widgets/history/line_chart_new.dart';
import 'package:symptom_tracker/views/widgets/tracker_info_widgets/value_tracker_info.dart';

class ChartPage extends StatefulWidget {
  // TODO - Add a away to show just one tracker from load

  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<DataLog> roseData = [];
  int duration = 7;

  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      const DropdownMenuItem(
        value: 7,
        child: Text("7 days"),
        alignment: Alignment.topRight,
      ),
      const DropdownMenuItem(
        value: 30,
        child: Text("30 days"),
        alignment: Alignment.topRight,
      ),
      const DropdownMenuItem(
        value: 90,
        child: Text("90 days"),
        alignment: Alignment.topRight,
      ),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height,
          child: Column(
            children: [
              // Add drop down picker with duration options 7-30-90
              DropdownButton(
              alignment: Alignment.centerRight,
              isExpanded: true,
              value: duration,
              onChanged: (int? newValue) {
                setState(() {
                  duration = newValue??0;
                });
              },
              items: dropdownItems),
              Expanded(
                  child: Row(
                children: [
                  //TODO - create a weight details widget - make weight a default tracker
                  Expanded(
                    child: ValueTrackerDisplay(
                      EventManager.selectedTarget.getWeightTracker(),
                      DateTime.now().subtract(Duration(days: duration)),
                      DateTime.now(),
                    ),
                  ),

                  Expanded(child: DietChart(duration)),
                ],
              )),
              Expanded(child: LineDataChart(span: duration, segments: duration > 7 ? 7 : 1),),
            ],
          ),
        );
  }
}
