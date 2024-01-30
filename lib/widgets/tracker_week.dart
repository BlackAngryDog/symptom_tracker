// stateless widget that displays the tracker for the week
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/trackable.dart';
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

  @override
  initState() {
    super.initState();

    trackerSubscription = EventManager.stream.listen((event) {
      if (event.event == EventType.trackerAdded ||
          event.event == EventType.targetChanged) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
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
              child: FutureBuilder<Trackable?>(
                  future: Trackable.load(EventManager.selectedTarget.id ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var trackable = snapshot.data ?? Trackable();
                      return ListView(
                        shrinkWrap: true,
                        children: trackable.trackOptions.map((info) {
                          return TrackerWeekInfo(
                              Tracker(trackable.id ?? '', info), date);
                        }).toList(),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
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
