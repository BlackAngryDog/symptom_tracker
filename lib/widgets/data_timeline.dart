import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/date_process_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/widgets/data_log_item.dart';
import 'package:symptom_tracker/widgets/time_line_item.dart';

class DataTimeLine extends StatefulWidget {
  final Trackable _trackable;

  const DataTimeLine(this._trackable, {Key? key}) : super(key: key);

  @override
  State<DataTimeLine> createState() => _DataTimeLineState();
}

class _DataTimeLineState extends State<DataTimeLine> {
  final Map<String, List<TimeLineEntry>> _data = {};
  var date = DateTime.now();
  var duration = const Duration(days: 1);
  bool reachedEnd = false;

  void getMoreData() async {
    var nextSet =
        await DataProcessManager.getTimeLine(date.subtract(duration), date);

    // get earliest date from data
    if (nextSet.isNotEmpty && nextSet.values.isNotEmpty) {
      var next = nextSet.values
          .where((element) => element.isNotEmpty)
          .map((e) => e.first.startDateTime)
          .reduce(
              (value, element) => value.isBefore(element) ? value : element);
      date = date.difference(next).inDays > duration.inDays
          ? next
          : date = date.subtract(duration);

      setState(() {
        _data.addEntries(
            nextSet.entries.where((element) => element.value.isNotEmpty));
      });
    } else {
      date = date.subtract(duration);
    }
  }

  @override
  void initState() {
    super.initState();
    /*
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(xValue, math.sin(xValue)));
        cosPoints.add(FlSpot(xValue, math.cos(xValue)));
      });
      xValue += step;
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    var keys = _data.keys.toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _data.length) {
          // Show your info

          return TimeLineItem(_data[keys[index]] ?? []);
        } else {
          getMoreData();
          return Center(child: CircularProgressIndicator());
        }
      },
      itemCount: _data.length + (reachedEnd ? 0 : 1),
    );
  }
  /*
  @override

  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).copyWith().size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: DataLog.getCollection(widget._trackable.id ?? "Default")
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data?.docs.map((doc) {
                return DataLogItem(DataLog.fromJson(
                    doc.id, doc.data() as Map<String, dynamic>));
              }).toList() as List<DataLogItem>,
            );
          }
        },
      ),

      /*child: FirebaseDatabaseListView(
        query: DatabaseTools.getRef(Tracker().getEndpoint()),
        itemBuilder: (context, snapshot) {
          Tracker tracker = Tracker.fromJson(
              snapshot.key, snapshot.value as Map<String, dynamic>);
          return TrackerItem(tracker);
        },
      ),

       */
    );
  }

   */
}
