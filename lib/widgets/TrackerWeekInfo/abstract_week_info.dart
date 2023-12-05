import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';

class AbsWeekInfo extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  final List<String> currValues = [
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0"
  ]; // TODO - GET TODYS COUNT FOR TRACKER

  AbsWeekInfo(this._tracker, this._trackerDate, {Key? key}) : super(key: key);

  void showControlPanel(BuildContext ctx, int index) {
    final currDay = DateTime.now().weekday - 1;
    final trackDay = _trackerDate.subtract(Duration(days: index));
    // TODO - Expand this display to look and feel better with more info (Date/adv etc)
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Card(
              child: Column(
                children: [
                  Text(trackDay.dateOnly.toString()),
                  TrackerControls(
                    _tracker,
                    trackDay,
                  ),
                ],
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
    while (i < 7) {
      var date = widget._trackerDate.add(Duration(days: -i));
      if (date.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
        //v.add(i.toString());
        v.add(await widget._tracker
                .getLastValueFor(date, includePrevious: false) ??
            "-");
      } else {
        v.add("-");
      }
      i++;
    }
    widget.currValues.clear();
    setState(() {
      widget.currValues.addAll(v);
    });
  }

  // TODO - 6 days of history with one Larger day for today, with name field taking up part og the height and seventh being full height.

  @override
  Widget build(BuildContext context) {
    var count = widget.currValues.length - 1;

    // Create a list of widgets
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              FittedBox(fit: BoxFit.fill,child: Text(widget._tracker.title??"", style: TextStyle(fontSize: 24), textAlign: TextAlign.start),),
              Container(height: 50.0, child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(count, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.showControlPanel(context, count - index);
                      },
                      child: getDay(count - index),
                    ),
                  );
                }),
              ),),
            ]),
          ),
          Expanded(flex: 1, child: GestureDetector(
            onTap: () {
              widget.showControlPanel(context, 6);
            },
            child: getDay(6),
          ),),
        ]),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("title"),
              Container(
                height: 100,
                color: Colors.lime,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(count, (index) {
                      return Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            widget.showControlPanel(context, count - index);
                          },
                          child: getDay(count - index),
                        ),
                      );
                          }),
                ),
              ),
            ],


          ),
        ),

        Expanded(
          flex:1 ,
          child: GestureDetector(
            onTap: () {
              widget.showControlPanel(context, 6);
            },
            child: getDay(6),
          ),
        ),


      ],
    );
  }

  Widget? getDay(int index) {
    return Container(
        // add a box decoration with round corners
        decoration: const BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        alignment: Alignment.center,
        child: Text(widget.currValues[index]));
  }
}
