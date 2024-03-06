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

class TrackerWeek extends StatefulWidget {
  const TrackerWeek({Key? key}) : super(key: key);

  @override
  State<TrackerWeek> createState() => _TrackerWeekState();
}

class _TrackerWeekState extends State<TrackerWeek> {
  var daysOfWeek = <String>['Mo', 'Tu', 'We', 'Tu', 'Fr', 'Sa', 'Su'];
  late StreamSubscription trackerSubscription;
  Map<Tracker,List<String>> trackerValues = {};

  @override
  initState() {
    super.initState();

    trackerSubscription = EventManager.stream.listen((event) {

      if (event.event == EventType.trackerAdded ||
          event.event == EventType.trackableChaned) {
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

  Future<Map<Tracker,List<String>>> getTrackerValues(DateTime trackerDate, {int numDays = 7}) async
  {

    LinkedHashMap<Tracker,List<String>> values = LinkedHashMap();
    var trackers = EventManager.selectedTarget.getTrackers();
    if (trackers.isEmpty)
      await EventManager.selectedTarget.getTrackOptions();

    // sort the trackers based on the tracker.option.order
    //trackers.sort((a, b) => a.option.order.compareTo(b.option.order));

    for (var tracker in trackers)
    {

      int i = 0;
      //tracker.option.order = trackerValues.length;
      values.putIfAbsent(tracker, () => []);

      while (i < numDays) {
        var date = trackerDate.add(Duration(days: -i));
        var currValue = await tracker.getValue(day: date);
        values[tracker]?.add(currValue);
        i++;
      }

    }
    trackerValues.addAll(values);

    return trackerValues;
  }

  Widget getWeek(DateTime date) {
    return SizedBox(
      height: MediaQuery.of(context).copyWith().size.height,
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
              child: FutureBuilder<Map<Tracker,List<String>>>(
                future: getTrackerValues(date),
                builder: (context, snapshot) {

                  if (trackerValues.entries.isNotEmpty == true) {
                    return ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                       //
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }

                          var preoptions = trackerValues.entries.map((tracker) {
                            return tracker.key.option.id.toString();
                          }).toList();

                          final String item = preoptions.removeAt(oldIndex);
                          preoptions.insert(newIndex, item);

                          EventManager.selectedTarget.loadTrackOptions(preoptions);
                          EventManager.selectedTarget.save(); // Save the data to tracker


                          // TODO - can theis be done after loading option data - if we use trakerbale info
                          /*
                          for (var tag in preoptions) {
                            // Save order to the track-options list
                            var option = trackerValues.entries.where((element) => element.key.option.id.toString() == tag).first.key.option;
                            option.order = preoptions.indexOf(tag);
                            option.save();
                          }

                           */

                          setState(() {
                            trackerValues.clear();
                            // TODO - Work out a way to be able to re-order data by using list rather than map
                            //final item = trackerValues.entries.removeAt(oldIndex);
                            //trackerValues.entries.insert(newIndex, item);
                          });
                      },
                      children: trackerValues.entries.map((tracker) {
                        return TrackerWeekInfo(tracker.key, date, tracker.value, key: GlobalKey());
                      }).toList(),
                    );

                      ListView(
                      shrinkWrap: true,
                      children: trackerValues.entries.map((tracker) {
                        return TrackerWeekInfo(tracker.key, date, tracker.value);
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
        height: MediaQuery.of(context).size.height,
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
          DateTime.now().subtract(Duration(days: itemIndex * 7)),
        ),
      ),
    );
    /*
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: true,
        autoPlay: false,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
        CarouselSlider.builder(
          itemCount: 15,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
              Container(
                child: Text(itemIndex.toString()),
              ),
        )
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Colors.amber),
              child: getWeek(
                DateTime.now().subtract(Duration(days: 10 - i * 7)),
              ),
            );
          },
        );
      }).toList(),
    );


     */
    /*child: FirebaseDatabaseListView(
        query: DatabaseTools.getRef(Tracker().getEndpoint()),
        itemBuilder: (context, snapshot) {
          Tracker tracker = Tracker.fromJson(
              snapshot.key, snapshot.value as Map<String, dynamic>);
          return TrackerItem(tracker);
        },
      ),

       */
  }
  /*
  @override
  Widget build(BuildContext context) {

    var daysOfWeek = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return GestureDetector(

      onHorizontalDragEnd: (dragDetail) {
        if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
          print("right");
        } else {
          print("left");
        }
      },



      child: Container(
        color: const Color.fromARGB(0,100,0,0),
        height: MediaQuery.of(context).copyWith().size.height,
        child: StreamBuilder<QuerySnapshot>(
          stream: DataLog.getCollection(widget.trackable.id ?? "Default")
              .orderBy('time', descending: true)
              .startAt([
            DateTime.now().subtract(const Duration(days: 7))
          ]).endAt([DateTime.now()]).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // create a days of the week container
              return ListView.builder(
                  itemCount: daysOfWeek.length,
                  itemBuilder: (_, index) {
                    bool isSameDate = true;

                    final item = daysOfWeek[index];
                    final currDay = DateTime.now().weekday;

                    return Container(
                      color: const Color.fromARGB(100,100,0,0),
                      child: Column(children: [

                        // get day of week as a string
                        Text(
                          item,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: _trackers.map((doc) {
                            return TrackerControls(
                                doc,
                                DateTime.now()
                                    .add(Duration(days: index - currDay)));
                          }).toList(),
                        ),
                      ]),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
  */
}
