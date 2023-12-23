import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/track_option.dart';

// discribes the setup of the tracker and creates log entries
class Tracker {
  // Tracking data
  String? id;

  // tracker title (does this need to be unique in data?)
  TrackOption option;
  String trackableID;

  List<DataLog> dataLog = [];

  Tracker(this.trackableID, this.option) {
    readLog(DateTime.now());
  }

  // TYPE - counter, quality, duration, value

  // VALUE -THIS IS NOT SAVED HERE AS THAT IS FOR THE LOG!

  // set/update log for today for this tracker...
  Future updateLog(dynamic value, DateTime date) async {
    if (trackableID == '') return;

    Duration diff = date.difference(DateTime.now());
    if (diff.inDays < 0) {
      // if date is not today, we need to add this as last entry
      date = date.endOfDay;
    }

    // GET ANY LOGS WITHIN THE TIMEFRAME AND UPDATE IT RATHER THAN CREATE A NEW LOG
    DateTime minTimeFrame = date.add(const Duration(hours: -1));
    List<DataLog> logs = await getLogs(minTimeFrame, date);
    DataLog? log = logs.firstOrNull;
    log ??= DataLog(option.id ?? "", date, value: value);
    log.time = date;
    log.value = value;
    log.save(trackableID);
  }

  // get data from logs for day ?
  Future readLog(DateTime date) async {
    if (trackableID == '') return;
    // Load data log for this tracker
    DateTime minTimeFrame = DateTime(date.year, date.month, date.day);
    List<DataLog> log = await getLogs(
        minTimeFrame, minTimeFrame.add(const Duration(hours: 24)));
    dataLog.addAll(log);
  }

  Future<String> getFirstEntry() async {
    if (trackableID == '') return '';
    return DataLog.getCollection(trackableID)
        .where('optionID', isEqualTo: option.id ?? '')
        .limit(1)
        .orderBy('time', descending: false)
        .get(const GetOptions(source: Source.cache))
        .then((data) {
      List<DataLog> log = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return log.firstOrNull?.value.toString() ?? '';
    });
  }

  Future<List<DataLog>> getLogs(DateTime start, DateTime end) async {
    if (trackableID == '') return [];
    return DataLog.getCollection(trackableID)
        .where('optionID', isEqualTo: option.id ?? '')
        .where('time', isGreaterThanOrEqualTo: start)
        .where('time', isLessThanOrEqualTo: end)
        .get(const GetOptions(source: Source.cache))
        .then((data) {
      List<DataLog> log = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return log;
    });
  }

  Future<DataLog?> getLastEntry(bool today, {DateTime? before}) async {
    if (trackableID == '') return null;

    DateTime date = before ?? DateTime.now();

    return await DataLog.getCollection(trackableID)
        .where('time', isLessThanOrEqualTo: date)
        .where('optionID', isEqualTo: option.id ?? '')
        .limit(1)
        .orderBy('time', descending: true)
        .get()
        .then((data) {
      List<DataLog> log = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      if (log.lastOrNull == null) return null;

      DataLog? lastEntry = log.lastOrNull;
      DateTime time = lastEntry!.time;
      Duration diff = date.difference(time);
      //print('days diff is ${diff.inDays}');
      if (today == true && diff.inDays >= 1) return null;

      return log.lastOrNull;
    });
  }

  Type typeOf<T>() => T;

  // get value based on TrackerOption autofill property
  Future<String> getAutoFillValue(bool today) async {
    if (trackableID == '') return '';

    switch (option.autoFill) {
      case AutoFill.last:
        return _getLastValue(today);
      case AutoFill.initial:
        return await getFirstEntry();
      case AutoFill.empty:
        return '';
    }

    return '';
  }

  // get last value for this tracker
  Future<String> _getLastValue(bool today) async {
    if (trackableID == '') return '';
    DataLog? dataLog = await getLastEntry(today);
    return dataLog?.value.toString() ?? '';
  }

  Future<String> getLastValueFor(DateTime day,
      {bool includePrevious = true}) async {
    if (trackableID == '') return '';
    DataLog? dataLog =
        await getLastEntry(!includePrevious, before: day.endOfDay);
    return dataLog?.value.toString() ??
        await getAutoFillValue(!includePrevious);
  }

  Future<List<dynamic>> getValuesFor(DateTime start, DateTime end) async {
    if (trackableID == '') return [];
    List<DataLog> logs = await getLogs(start, end);
    List<dynamic> values = logs.map((log) => log.value).toList();
    return values;
  }

  Tracker.fromTrackOption(String owner, this.option) : trackableID = owner {
    readLog(DateTime.now());
  }
}
