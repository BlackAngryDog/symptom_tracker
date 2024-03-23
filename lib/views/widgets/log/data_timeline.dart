
import 'package:flutter/material.dart';
import 'package:symptom_tracker/managers/date_process_manager.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';
import 'package:symptom_tracker/views/widgets/log/log_time_line_item.dart';

class DataTimeLine extends StatefulWidget {
  final Trackable _trackable;

  const DataTimeLine(this._trackable, {Key? key}) : super(key: key);

  @override
  State<DataTimeLine> createState() => _DataTimeLineState();
}

class _DataTimeLineState extends State<DataTimeLine> {
  final List<LogTimeLineEntry> _data = [];

  var date = DateTime.now();
  var duration = const Duration(days: 30);
  bool reachedEnd = false;

  void getMoreData() async {
    var nextSet =
        await DataProcessManager.getTimeLine(date.subtract(duration), date);

    // get earliest date from data
    if (nextSet.isNotEmpty && nextSet.isNotEmpty) {
      var next = nextSet
          .map((e) => e.date)
          .reduce(
              (value, element) => value.isBefore(element) ? value : element);

      date = date.difference(next).inDays > duration.inDays
          ? next
          : date = date.subtract(duration);

      setState(() {
        _data.addAll(nextSet);
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

    var numDays = DateTime.now().difference(date).inDays;
    var i = 0;
    var count = _data.length;
    // BUILD MY DATA
    List<LogTimeLineEntry> events = List.from(_data);
    List<LogTimeLineItem> entries = [];
    //var entryDate = DateTime.now();
    for (i; i < numDays; i++) {
      var nextDate = DateTime.now().subtract(Duration(days: i));
      var entriesForDay = events
          .where((element) =>
              element.date.difference(nextDate).inDays == 0)
          .toList();

      entries.add(LogTimeLineItem(nextDate, const []));

      if (entriesForDay.isNotEmpty) {

        entries.add(LogTimeLineItem(nextDate, entriesForDay, comparisonLog: _data));

        for (var entry in entriesForDay) {
          events.remove(entry);
        }

        continue;
      }


    }

    //var dataCopy = Map.castFrom(_data);
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < entries.length) {
          return entries[index];
        } else {
          getMoreData();
          return const Center(child: CircularProgressIndicator());
        }
      },
      itemCount: entries.length + (reachedEnd ? 0 : 1),
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
    );
  }

   */
}
