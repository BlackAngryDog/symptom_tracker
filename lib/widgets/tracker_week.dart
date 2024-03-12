// stateless widget that displays the tracker for the week
import 'dart:async';
import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/widgets/tracker_week_info.dart';

import '../model/event_manager.dart';
import '../model/tracker.dart';
import 'TrackerWeekInfo/week_info_grid.dart';

class TrackerVO {
  final Tracker tracker;
  final List<String> values;

  TrackerVO(this.tracker, this.values);
}

class TrackerWeek extends StatefulWidget {
  const TrackerWeek({Key? key}) : super(key: key);

  @override
  State<TrackerWeek> createState() => _TrackerWeekState();
}

class _TrackerWeekState extends State<TrackerWeek> {
  var daysOfWeek = <String>['Mo', 'Tu', 'We', 'Tu', 'Fr', 'Sa', 'Su'];
  late StreamSubscription trackerSubscription;
  //Map<Tracker, List<String>> trackerValues = {};
  final List<TrackerVO> trackerValues = [];
  late DateTime currDate;

  @override
  initState() {
    currDate = DateTime.now();
    super.initState();

    trackerSubscription = EventManager.stream.listen((event) {
      if (event.event == EventType.trackerAdded ||
          event.event == EventType.trackableChanged) {
        setState(() {
          trackerValues.clear();
          //getTrackerValues(DateTime.now());
        });
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  Future<List<TrackerVO>> getTrackerValues(DateTime trackerDate,
      {int numDays = 7}) async
  {

    if (currDate.difference(trackerDate).inDays != 0) trackerValues.clear();

    if (trackerValues.isNotEmpty) return trackerValues;

    currDate = trackerDate;

    var trackers = EventManager.selectedTarget.getTrackers();
    if (trackers.isEmpty)
    {
      await EventManager.selectedTarget.getTrackOptions();
    }

    for (var tracker in trackers) {
      int i = 0;
      //tracker.option.order = trackerValues.length;
      //values.putIfAbsent(tracker, () => []);
      var vo = TrackerVO(tracker, []);


      while (i < numDays) {
        var date = trackerDate.add(Duration(days: -i));
        var currValue = await tracker.getValue(day: date);
        vo.values.add(currValue);
        i++;
      }
      trackerValues.add(vo);
    }
    return trackerValues;
  }

  Widget getWeek(DateTime date) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .copyWith()
          .size
          .height,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat.yMMMd().format(date),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Flexible(child: WeekInfoGrid(daysOfWeek, date)),
            Expanded(
              flex: 9,
              // Load Trackers
              child: FutureBuilder<List<TrackerVO>>(
                future: getTrackerValues(date),
                builder: (context, snapshot) {
                  if (trackerValues.isNotEmpty == true) {
                    return ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        //
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }

                        var preoptions = trackerValues.map((vo) {
                          return vo.tracker.option.id.toString();
                        }).toList();

                        final String item = preoptions.removeAt(oldIndex);
                        preoptions.insert(newIndex, item);
                        // create an anonymous async Future

                        EventManager.selectedTarget.saveTrackIDs(preoptions);
                        setState(() {
                          var child = trackerValues.removeAt(oldIndex);
                          trackerValues.insert(newIndex, child);
                        });


                      },
                      children: trackerValues.map((vo) {
                        return TrackerWeekInfo(
                            vo.tracker, date, vo.values, key: GlobalKey());
                      }).toList(),
                    );

                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final trackers = EventManager.selectedTarget.trackers
    //   .map((e) => Tracker(EventManager.selectedTarget.id ?? '', e))
    //   .toList();

    // TODO - Need to load trakers on switch

    return CarouselSlider.builder(
      options: CarouselOptions(
        height: MediaQuery
            .of(context)
            .size
            .height,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: true,
        autoPlay: false,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
      itemCount: 15,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          Container(
            child: getWeek(
              DateTime.now().subtract(Duration(days: itemIndex * 7))
            ),
          ),
    );
  }
}


