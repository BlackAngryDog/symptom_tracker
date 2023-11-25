// stateless widget that displays the tracker for the week
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/widgets/data_log_item.dart';
import 'package:symptom_tracker/widgets/tracker_controls.dart';
import 'package:symptom_tracker/widgets/tracker_week_info.dart';

import '../model/event_manager.dart';
import '../model/tracker.dart';
import 'TrackerWeekInfo/week_info_grid.dart';

class TrackerWeek extends StatefulWidget {
  final Trackable trackable;
  TrackerWeek(this.trackable, {Key? key}) : super(key: key);

  @override
  State<TrackerWeek> createState() => _TrackerWeekState();
}

class _TrackerWeekState extends State<TrackerWeek> {
  late final List<Tracker> _trackers;
  var daysOfWeek = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  initState() {
    super.initState();

    _trackers = EventManager.selectedTarget.trackers
        .map((e) => Tracker(EventManager.selectedTarget.id ?? '',
            type: e.trackType, title: e.title))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      height: MediaQuery.of(context).copyWith().size.height,
      child: Stack(
        children: [
          WeekInfoGrid(daysOfWeek),
          ListView(
            shrinkWrap: true,
            children: _trackers.map((doc) {
              return TrackerWeekInfo(doc, DateTime.now());
            }).toList(),
          ),
        ],
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
