import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';

class DietTrackerWeekInfo extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  const DietTrackerWeekInfo(this._tracker, this._trackerDate, {Key? key})
      : super(key: key);

  @override
  State<DietTrackerWeekInfo> createState() => _DietTrackerWeekInfoState();
}

class _DietTrackerWeekInfoState extends State<DietTrackerWeekInfo> {
  final List<String> currValues = [
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0"
  ]; // TODO - GET TODYS COUNT FOR TRACKER
  String subtitle = 'count today is 0';

  @override
  void initState() {
    super.initState();
    getCurrValue();
  }

  Future getCurrValue() async {
    int i = 0;
    final currDay = DateTime.now().weekday;
    List<String> v = [];
    while (i++ < 7) {
      v.add(await widget._tracker.getLastValueFor(
          widget._trackerDate.add(Duration(days: i - currDay))));
    }
    currValues.clear();
    setState(() {
      currValues.addAll(v);
    });
  }

  void showHistory(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => TrackerSummeryPage(
          widget._tracker,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var daysOfWeek = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 50, crossAxisSpacing: 0, mainAxisSpacing: 0),
      itemCount: daysOfWeek.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext ctx, index) {
        // Add your card/widget/grid element here
        return Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Column(
            children: [Text(currValues[index])],
          ),
        );
      },
    );
  }
}
