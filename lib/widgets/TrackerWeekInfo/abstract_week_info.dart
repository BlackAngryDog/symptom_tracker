import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';

class AbsWeekInfo extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  final List<String> currValues = ["0", "0", "0", "0", "0", "0", "0"]; // TODO - GET TODYS COUNT FOR TRACKER

  AbsWeekInfo(this._tracker, this._trackerDate, {Key? key})
      : super(key: key);

  void showControlPanel(BuildContext ctx, int index) {
    final currDay = DateTime.now().weekday - 1;
    // TODO - Expand this display to look and feel better with more info (Date/adv etc)
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: TrackerControls(
              _tracker,
              _trackerDate.add(
                Duration(days: index + -currDay),
              ),
            ),
          );
        });
  }

  @override
  State<AbsWeekInfo> createState() => AbsWeekInfoState();
}

class AbsWeekInfoState<T extends AbsWeekInfo> extends State<T> {
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
      if (event.event == EventType.trackerChanged &&
          event.tracker == widget._tracker) {
        getCurrValue();
      }
    });
    getCurrValue();
  }

  Future getCurrValue() async {
    // TODO: should we run this from today - 7 or keep is as week starting?

    // TODO - Can we change this to have a range - over day, week, month so that the format can easily change depending on data ?

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
    widget.currValues.clear();
    setState(() {
      widget.currValues.addAll(v);
    });
  }

  // TODO - 6 days of history with one Larger day for today, with name field taking up part og the height and seventh being full height.

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 50,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: widget.currValues.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext ctx, index) {
        // Add your card/widget/grid element here
        return GestureDetector(
          onTap: () {
            widget.showControlPanel(context, index);
          },
          child: getDay(index),
        );
      },
    );
  }

  Widget? getDay(int index){
    return Container(
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
        child: Text(widget.currValues[index]));
  }
}
