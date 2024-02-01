import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';
import 'package:symptom_tracker/widgets/add_tracker_popup.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';

class AbsWeekInfo extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  final List<String> currValues;
  bool _bottomSheetOpen = false;

  int _selectedIndex = -1;
  final List<IconData> trendIcons = List<IconData>.filled(7, Icons.arrow_right);

  AbsWeekInfo(this._tracker, this._trackerDate, this.currValues, {Key? key}) : super(key: key);

  void showControlPanel(BuildContext ctx, int index) {
    _selectedIndex = index;
    final trackDay = _trackerDate.subtract(Duration(days: index));

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
    _bottomSheetOpen = true;
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
        if (widget._bottomSheetOpen == true) {
          Navigator.pop(context);
          widget._bottomSheetOpen = false;

        }else{
          getCurrValue();
        }

      }
    });
  }

  IconData getTrendIcon(String lastValue, String currValue) {
    var last = double.tryParse(lastValue) ?? 0;
    var curr = double.tryParse(currValue) ?? 0;

    var icon = Icons.arrow_right;
    if (curr > last) {
      icon = Icons.arrow_drop_up;
    } else if (curr < last) {
      icon = Icons.arrow_drop_down;
    }
    return icon;
  }

  void _editTrackerPopup(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: AddTracker((option) {
              _editTrackerPopup(context);
            }, tracker: widget._tracker),
          );
        });
  }

  void _showHistory(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => TrackerSummeryPage(
          widget._tracker,
        ),
      ),
    );
  }


  Future<List<String>> getCurrValue() async {

    int i = 0;
    while (i < 7) {
      var date = widget._trackerDate.add(Duration(days: -i));
      var prevDate = widget._trackerDate.add(Duration(days: -i + 1));

      var currValue = await widget._tracker.getValue(day: date);
      var prevValue = await widget._tracker.getValue(day: prevDate);

      widget.currValues[i] = currValue;
      widget.trendIcons[i] = getTrendIcon(prevValue, currValue);

      i++;
    }

    setState(() {

    });

    return widget.currValues;
  }

  @override
  Widget build(BuildContext context) {
    return InfoItem();
  }

  Widget InfoItem() {
    var count = widget.currValues.length - 1;
    IconData? icon;
    if (widget._tracker.option.icon != null) {
      var iconDataJson = jsonDecode(widget._tracker.option.icon ?? "");
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (icon != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                icon,
                                size: 24,
                              ),
                            ),
                          Text(widget._tracker.option.title ?? "",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => {_editTrackerPopup(context)},
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () => {_showHistory(context)},
                                  icon: const Icon(Icons.history)),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
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

        child: const Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: EdgeInsets.all(12.0),
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
                  style: const TextStyle(
                      backgroundColor: Colors.transparent,
                      fontWeight: FontWeight.bold),
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
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: BoxShape.rectangle,
        border: index == widget._selectedIndex
            ? Border.all(color: Colors.blueAccent, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurStyle: BlurStyle.normal,
            blurRadius: 4.0 * elevation,
            spreadRadius: 0.0,
            offset: Offset(3.0 * elevation,
                3.0 * elevation), // shadow direction: bottom right
          )
        ],
        borderRadius: const BorderRadius.all(Radius.circular(50)));
  }
}
