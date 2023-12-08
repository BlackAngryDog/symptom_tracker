import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';

class AbsWeekInfo extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  final List<String> currValues = ["M", "T", "W", "T", "F", "S", "S"]; // TODO - GET TODYS COUNT FOR TRACKER
  int _selectedIndex = -1;

  AbsWeekInfo(this._tracker, this._trackerDate, {Key? key}) : super(key: key);

  void showControlPanel(BuildContext ctx, int index) {
    _selectedIndex = index;
    final trackDay = _trackerDate.subtract(Duration(days: index));
    // TODO - Expand this display to look and feel better with more info (Date/adv etc)

    EventManager.dispatchUpdate(
        UpdateEvent(EventType.trackerChanged, tracker: _tracker));

    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(child: Text(trackDay.dateOnly.toString())),
                    TrackerControls(
                      _tracker,
                      trackDay,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).whenComplete(() => {
          _selectedIndex = -1,
          EventManager.dispatchUpdate(
              UpdateEvent(EventType.trackerChanged, tracker: _tracker))
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
        setState(() {});
        getCurrValue();
      }
    });
    getCurrValue();
  }

  Future getCurrValue() async {
    // TODO: should we run this from today - 7 or keep is as week starting?

    // TODO - Can we change this to have a range - over day, week, month so that the format can easily change depending on data ?

    int i = 0;
    List<String> v = [];
    while (i < 7) {
      var date = widget._trackerDate.add(Duration(days: -i));
      if (date.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch) {
        //v.add(i.toString());
        v.add(await widget._tracker
            .getLastValueFor(date, includePrevious: false));
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
    IconData? icon;
    if (widget._tracker.icon != null) {
      var iconDataJson = jsonDecode(widget._tracker.icon ?? "");
      icon = IconData(iconDataJson['codePoint'],
          fontFamily: iconDataJson['fontFamily']);
    }

    // Create a list of widgets
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          children: [
                            if (icon != null)
                              Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Icon(
                                  icon,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            Text(widget._tracker.title ?? "",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold) ,
                                textAlign: TextAlign.start),
                          ],
                        ),
                      ),
                      Container(
                        height: 40.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(count, (index) {
                            return getChild(count - index);
                          }),
                        ),
                      ),
                    ]),
              ),
              getChild(0),
            ]),
      ),
    );
  }

  Widget getChild(int index) {
    var v = widget.currValues[index];
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          onTap: () {
            widget.showControlPanel(context, index);
          },
          child: v.isEmpty ? getEmpty(index) : getDay(index),
        ),
      ),
    );
  }

  Widget getEmpty(int index) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        // add a box decoration with round corners
        decoration: getContainerDecoration(index),
        alignment: Alignment.center,

        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDay(int index) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        // add a box decoration with round corners
        decoration: getContainerDecoration(index),

        alignment: Alignment.center,

        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.fitHeight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.currValues[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(backgroundColor: Colors.transparent,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Decoration getContainerDecoration(int index, {double elevation = .5}) {
    return BoxDecoration(
        color: Colors.white54,
        shape: BoxShape.rectangle,
        border: index == widget._selectedIndex
            ? Border.all(color: Colors.blueAccent, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurStyle: BlurStyle.normal,
            blurRadius: 4.0*elevation,
            spreadRadius: 0.0,
            offset: Offset(3.0*elevation, 3.0*elevation), // shadow direction: bottom right
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(50)));
  }
}
