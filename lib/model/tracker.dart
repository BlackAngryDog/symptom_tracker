import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/database_objects/data_log.dart';
import 'package:symptom_tracker/model/database_objects/track_option.dart';

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
    log.save();
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

  Future<List<DataLog>> getLogs(DateTime start, DateTime end) async {
    if (trackableID == '') return [];
    return DataLog.collection(trackableID)
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

  Future<DataLog?> _getFirstEntry() async {
    if (trackableID == '') return null;

    return DataLog.collection(trackableID)
        .where('optionID', isEqualTo: option.id ?? '')
        .orderBy('time', descending: false)
        .limit(1)
        .get(const GetOptions(source: Source.cache))
        .then((data) {
      List<DataLog> log = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return log.firstOrNull;
    });
  }

  Future<DataLog?> _getLastEntry({DateTime? date, bool? dateOnly}) async {
    if (trackableID == '') return null;

    var end = (date ?? DateTime.now()).endOfDay;
    var start =
        dateOnly == true ? (date ?? DateTime.now()).startOfDay : DateTime(2000);

    return DataLog.collection(trackableID)
        .where('optionID', isEqualTo: option.id ?? '')
        .where('time', isGreaterThanOrEqualTo: start)
        .where('time', isLessThanOrEqualTo: end)
        .orderBy('time', descending: true)
        .limit(1)
        .get(const GetOptions(source: Source.cache))
        .then((data) {
      List<DataLog> log = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return log.firstOrNull;
    });
  }

  Type typeOf<T>() => T;

  // get value based on TrackerOption autofill property
  Future<String> getValue({DateTime? day}) async {
    return await getLog(day: day).then((log) => log?.value.toString() ?? '');
  }

  // get value based on TrackerOption autofill property
  Future<DataLog?> getLog({DateTime? day}) async {
    if (trackableID == '') return null;

    // get log for this day
    var log = await _getLastEntry(date: day, dateOnly: true);
    if (log != null) return log;

    // get autofill value if log not available for this day
    switch (option.autoFill) {
      case AutoFill.last:
        log = await _getLastEntry(date: day);
        break;
      case AutoFill.initial:
        log = await _getFirstEntry();
        break;
    }

    return log;
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
