import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';

class TrackerButtonGrid extends StatefulWidget {
  TrackerButtonGrid({Key? key}) : super(key: key);

  @override
  State<TrackerButtonGrid> createState() => _TrackerButtonGridState();
}

class _TrackerButtonGridState extends State<TrackerButtonGrid> {
  Tracker? _selectedTracker;

  final db = FirebaseFirestore.instance;
  bool test = false;

  late final List<Tracker> _trackers;

  @override
  initState() {
    super.initState();
    _trackers = EventManager.selectedTarget.trackers
        .map((e) => Tracker(EventManager.selectedTarget.id ?? '', type: e.trackType, title: e.title))
        .toList();
  }

  int getMaxCount(int length) {
    double d = length.toDouble();

    //if (d % 5 == 0) return 5;
    //if (d % 4 == 0) return 4;
    if (d % 3 == 0) return 3;
    if (d % 2 == 0) return 2;
    return (d / 2).round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: getMaxCount(_trackers.length),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 150,
          childAspectRatio: .1,
        ),
        children: _trackers.map((tracker) {
          return GestureDetector(
            child: TrackerItem(tracker),
            onTap: () => {
              setState(() {
                Navigator.of(context).pop();
                _selectedTracker = tracker;
                if (_selectedTracker != null) EventManager.selectedTracker = _selectedTracker;
                ;
              }),
            },
          );
        }).toList(),
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        //stream: Tracker.getCollection(_trackable.id ?? "default").where('type', isEqualTo: "counter").snapshots(),
        stream: Tracker.getCollection(EventManager.selectedTarget.id ?? "default").where('type', isNotEqualTo: 'diet').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Card(
              child: CircularProgressIndicator(),
              color: Colors.transparent,
            );
          } else {
            return GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getMaxCount(snapshot.data?.docs.length ?? 0),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 150,
                childAspectRatio: .1,
              ),
              children: snapshot.data?.docs.map((doc) {
                return GestureDetector(
                  child: TrackerItem(Tracker.fromJson(doc.id, doc.data() as Map<String, dynamic>)),
                  onTap: () => {
                    setState(() {
                      Navigator.of(context).pop();
                      _selectedTracker = Tracker.fromJson(doc.id, doc.data() as Map<String, dynamic>);
                      if (_selectedTracker != null) EventManager.selectedTracker = _selectedTracker;
                      ;
                    }),
                  },
                );
              }).toList() as List<Widget>,
            );
          }
        },
      ),


    );
  }

 */
}
