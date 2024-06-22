import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/pages/tracker_Summery.dart';
import 'package:symptom_tracker/views/widgets/home/tracker_week_info/abstract_week_info.dart';

class DietTrackerWeekInfo extends AbsWeekInfo{
  final Tracker _tracker;
  final DateTime _trackerDate;
  DietTrackerWeekInfo(this._tracker, this._trackerDate, _currValues, {Key? key})
      : super(_tracker, _trackerDate, _currValues, key: key);

  @override
  State<DietTrackerWeekInfo> createState() => _DietTrackerWeekInfoState();
}

class _DietTrackerWeekInfoState extends AbsWeekInfoState<DietTrackerWeekInfo> {

  @override
  Future<List<String>> getCurrValue() async {

    int i = 0;
    while (i < 7) {
      var date = widget._trackerDate.add(Duration(days: -i));
      var prevDate = widget._trackerDate.add(Duration(days: -i + 1));

      var currValue = await widget._tracker.getValue(day: date);
      var prevValue = await widget._tracker.getValue(day: prevDate);

      widget.currValues[i] = currValue.split(",").length.toString();
      widget.trendIcons[i] = getTrendIcon(prevValue, currValue);

      i++;
    }

    setState(() {

    });

    return widget.currValues;
  }
}
