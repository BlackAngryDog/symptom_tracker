import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/diet_option.dart';
import 'package:symptom_tracker/model/track_option.dart';

import 'tracker.dart';

// Used to store details of thing bing tracked (a group of trackers)
class Trackable {
  // Trackable object to store tracked data
  String? userID;
  String? id;
  String? title;

  Tracker? _dietTracker;

  List<TrackOption> trackers = [];

  List<DataLog> _log = [];
  List<DataLog> get log => _log;

  Trackable({this.title});

  /*
    Get log - between dates (retrieve all the information saved into the data logs )


   */
  //retrieve all the information saved into the data logs [from] [to]
  //List<DataLog> getLog(DateTime from, DateTime to) {
  //  List<DataLog> list = <DataLog>{} as List<DataLog>;
  //  return list;
  //}

  // when a tracker changes update the log ()
  //void updateLog() {}

  // GET A DIET TRACKER FOR LOGGIN (STANDARD TRACKERS NEED FOR IMPLEMENTATION)
  Tracker getDietTracker() {
    if (_dietTracker != null) return _dietTracker as Tracker;

    _dietTracker = Tracker(id ?? '', title: 'Diet Tracker', type: 'diet');
    return _dietTracker as Tracker;
    /*
    Tracker? query = await Tracker.getCollection(id!).where("type", isEqualTo: 'diet').get().then(
      (res) async {
        if (res.docs.isNotEmpty) {
          return Tracker.fromJson(res.docs.first.id, res.docs.first.data() as Map<String, dynamic>);
        } else {
          return await Tracker(id!, title: 'Diet Tracker', type: 'diet').save();
        }
      },
      onError: (e) => Tracker(id!, title: 'Diet Tracker', type: 'diet').save(),
    );
    _dietTracker = query;
    return _dietTracker as Tracker;
    // Create tracker as no id saved
    if (_dietTracker == null) {
      _dietTracker = await Tracker(id!, title: 'Diet Tracker', type: 'diet').save();
      return _dietTracker as Tracker;
    }

    // Get Tracker from ID - could use First or Null ?
    final doc = Tracker.getCollection(id!).doc(_dietTrackerId);

    _dietTracker = doc
        .get()
        .then(
          (snapshot) => Tracker.fromJson(doc.id, snapshot.data() as Map<String, dynamic>),
        )
        .catchError(
      (error, stackTrace) {
        print(error);
      },
    ) as Tracker;

    return _dietTracker as Tracker;

     */
  }

  Future<List<DataLog>> getDataLogs(DateTime start, DateTime end) async {
    List<DataLog> logs = [];
    if (id == null) return logs;

    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day, 11, 59, 59);

    return await DataLog.getCollection(id ?? "Default").where('time', isGreaterThanOrEqualTo: start).where('time', isLessThanOrEqualTo: end).get(const GetOptions(source: Source.serverAndCache)).then((data) {
      logs = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      print("LOADED DATA ${start} to ${end} cound is ${logs.length}");
      return logs;
    }); // TODO - ADD ERROR
  }

  // PERSISTANCE

  Future save() async {
    CollectionReference collection = getCollection();
    if (id != null) {
      Map<dynamic, dynamic> map = toJson();
      collection.doc(id).set(map).then((value) => print("updated user")).catchError((error) => print("Failed to add user: $error"));
    } else {
      await collection.add(toJson()).then((value) => {id = value.id}).catchError((error) => print("Failed to add user: $error"));
    }
  }

  static CollectionReference getCollection() {
    return FirebaseFirestore.instance.collection('users').doc(DatabaseTools.getUserID()).collection('trackable');
  }

  static Future<Trackable> load(String key) async {
    final doc = getCollection().doc(key);

    return doc.get().then(
      (snapshot) {
        return Trackable.fromJson(doc.id, snapshot.data() as Map<String, dynamic>);
      },
    ).catchError(
      (error, stackTrace) {
        print('error $error');
        return Trackable();
      },
    );
  }

  Trackable.fromJson(String? key, Map<String, dynamic> json) {
    id = key;
    title = json['title'];
/*
    Map<String, dynamic> map = json['trackers'];
    var test = map.entries.map<TrackOption>((e) {
      return TrackOption.fromJson('', e.value as Map<String, dynamic>);
    }).toList();
    trackers = test as List<TrackOption>;
*/
    trackers = json['trackers'] is Map
        ? json['trackers'].entries.map<TrackOption>((e) {
            return TrackOption.fromJson('', e.value as Map<String, dynamic>);
          }).toList()
        : [];
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'trackers': Map<String, dynamic>.fromEntries(trackers.map((value) => MapEntry<String, dynamic>(value.title ?? '', value.toJson()))),
      };
}
