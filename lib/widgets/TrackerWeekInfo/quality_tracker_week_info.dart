import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';

class QualityTrackerWeekInfo extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;

  const QualityTrackerWeekInfo(this._tracker, this._trackerDate, {Key? key})
      : super(key: key);

  @override
  State<QualityTrackerWeekInfo> createState() => _QualityTrackerWeekInfoState();
}

class _QualityTrackerWeekInfoState extends State<QualityTrackerWeekInfo> {
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
  late StreamSubscription trackerSubscription;

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    trackerSubscription = EventManager.stream.listen((event) {
      if (event.event == EventType.trackerChanged && event.tracker == widget._tracker) {
        getCurrValue();
      }
    });
    getCurrValue();

  }

  Future getCurrValue() async {
    int i = 0;
    final currDay = DateTime.now().weekday;
    List<String> v = [];
    while (i++ < 7) {
      var date = widget._trackerDate.add(Duration(days: i - currDay));
      if (date.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
        v.add(await widget._tracker.getLastValueFor(date, includePrevious:false)??"-");
      }else{
        v.add("-");
      }
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

  void _showControlPanel(BuildContext ctx, int index) {
    final currDay = DateTime.now().weekday-1;

    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: TrackerControls(
              widget._tracker,
              widget._trackerDate.add(
                Duration(days: index+ - currDay),
              ),
            ),
          );
        });
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

        return GestureDetector(
          onTap: () {
            _showControlPanel(context, index);
          },
          child: Container(
            // add a box decoration with round corners
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 45,
                ),
                Center(
                  child: Text(
                    currValues[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(backgroundColor: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
