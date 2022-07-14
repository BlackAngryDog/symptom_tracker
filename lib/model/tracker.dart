import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:collection/collection.dart';

// discribes the setup of the tracker and creates log entries
class Tracker {
  // Tracking data
  String? id;

  // tracker title (does this need to be unique in data?)
  String? title;
  String? userID;
  String trackableID;
  String? type;

  List<DataLog> dataLog = [];

  Tracker(this.trackableID, {this.title, this.type}) {
    readLog();
  }

  // TYPE - counter, quality, duration, value

  // VALUE -THIS IS NOT SAVED HERE AS THAT IS FOR THE LOG!

  // set/update log for today for this tracker...
  Future updateLog(dynamic value) async {
    // GET ANY LOGS WITHIN THE TIMEFRAME AND UPDATE IT RATHER THAN CREATE A NEW LOG
    DateTime minTimeFrame = DateTime.now().add(const Duration(hours: -1));
    List<DataLog> logs = await getLogs(minTimeFrame, DateTime.now());
    DataLog? log = logs.firstOrNull;
    log ??= DataLog(trackableID, DateTime.now(),
        title: title, type: type, value: value);
    log.time = DateTime.now();
    log.value = value;
    log.save();
  }

  // get data from logs for day ?
  Future readLog() async {
    // Load data log for this tracker
    DateTime minTimeFrame =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    List<DataLog> log = await getLogs(
        minTimeFrame, minTimeFrame.add(const Duration(hours: 24)));
    //.where((element) => element.title == title).toList();
    print("DAYS LOG IS ${log.toString()}");
    dataLog.addAll(log);
  }

  Future<List<DataLog>> getLogs(DateTime start, DateTime end) async {
    print(' Getting tracker logs ');

    return DataLog.getCollection(trackableID)
        .where('title', isEqualTo: title ?? 'Default')
        .where('time', isGreaterThanOrEqualTo: start)
        .where('time', isLessThanOrEqualTo: end)
        .get()
        .then((data) {
      List<DataLog> log = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      print(' got tracker logs ${log.length}');
      return log;
    });
  }

  Future<DataLog?> getLastEntry(bool today, {DateTime? before}) async {
    if (before != null) print(before.toString());

    return await DataLog.getCollection(trackableID)
        .where('time', isLessThanOrEqualTo: before ?? DateTime.now())
        .where('title', isEqualTo: title ?? 'Default')
        .limit(1)
        .orderBy('time', descending: true)
        .get()
        .then((data) {
      List<DataLog> log = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      if (before != null) print(before.toString());

      if (log.lastOrNull == null) return null;

      DataLog? lastEntry = log.lastOrNull;
      DateTime time = lastEntry!.time;
      Duration diff = DateTime.now().difference(time);
      print('days diff is ${diff.inDays}');
      if (today == true && diff.inDays >= 1) return null;

      return log.lastOrNull;
    });
  }

  Type typeOf<T>() => T;

  Future<String> getLastValue(bool today) async {
    DataLog? dataLog = await getLastEntry(today);
    return dataLog?.value.toString() ?? '';
  }

  Future<String> getLastValueFor(DateTime day) async {
    DataLog? dataLog = await getLastEntry(false,
        before: DateTime(day.year, day.month, day.day, 23, 59));
    return dataLog?.value.toString() ?? '';
  }

  Future<List<dynamic>> getValuesFor(DateTime start, DateTime end) async {
    List<DataLog> logs = await getLogs(start, end);
    List<dynamic> values = logs.map((log) => log.value).toList();
    return values;
  }

  // PERSISTANCE

  Tracker save() {
    CollectionReference collection = getCollection(trackableID);
    if (id != null) {
      collection
          .doc(id)
          .set(toJson())
          .then((value) => print("Tracker Saved"))
          .catchError((error) => print("Failed to save tracker: $error"));
    } else {
      collection
          .add(toJson())
          .then((value) => print("Tracker created"))
          .catchError((error) => print("Failed to create tracker: $error"));
    }

    return this;
  }

  static CollectionReference getCollection(String owner) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(DatabaseTools.getUserID())
        .collection('trackable')
        .doc(owner)
        .collection('trackers');
  }

  static Future<Tracker> load(String key) async {
    return Tracker.fromJson(key, await AbsSavable.loadJson(key));
  }

  Tracker.fromJson(String? key, Map<String, dynamic> json)
      : trackableID = json['trackableID'] {
    id = key;
    title = json['title'];
    type = json['type'];
    readLog();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'trackableID': trackableID,
        'title': title,
        'type': type,
      };
}
