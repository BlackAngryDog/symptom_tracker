// stateless widget that displays the tracker for the week
import 'dart:async';

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
      if (event.event == EventType.trackerAdded || event.event == EventType.targetChanged) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //final trackers = EventManager.selectedTarget.trackers
     //   .map((e) => Tracker(EventManager.selectedTarget.id ?? '', e))
     //   .toList();

    // TODO - Need to load trakers on switch

    return SizedBox(
      height: MediaQuery.of(context).copyWith().size.height,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(child: WeekInfoGrid(daysOfWeek, DateTime.now())),
            Expanded(
              flex: 9,
              // Load Trackers
              child: FutureBuilder<Trackable?>(
                  future:
                  Trackable.load(EventManager.selectedTarget.id??''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var trackable = snapshot.data ?? Trackable();
                      return ListView(
                        shrinkWrap: true,
                        children: trackable.trackers.map((info) {
                          return TrackerWeekInfo(Tracker(trackable.id ?? '', info), DateTime.now());
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
