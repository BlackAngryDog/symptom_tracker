import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';

import 'tracker.dart';

// Used to store details of thing bing tracked (a group of trackers)
class Trackable {
  // Trackable object to store tracked data
  String? userID;
  String? id;
  String? title;

  List<Tracker> _trackers = [];
  List<Tracker> get trackers => _trackers;

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

  Future<List<DataLog>> getDataLogs(DateTime start, DateTime end) async {
    List<DataLog> logs = [];
    if (id == null) return logs;

    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day, 11, 59, 59);

    return await DataLog.getCollection(id ?? "Default")
        .where('time', isGreaterThanOrEqualTo: start)
        .where('time', isLessThanOrEqualTo: end)
        .get(const GetOptions(source: Source.serverAndCache))
        .then((data) {
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
      collection
          .doc(id)
          .set(toJson())
          .then((value) => print("updated user"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      await collection
          .add(toJson())
          .then((value) => {id = value.id})
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  static CollectionReference getCollection() {
    return FirebaseFirestore.instance.collection('users').doc(DatabaseTools.getUserID()).collection('trackable');
  }

  static Future<dynamic> load(String key) async {
    return Trackable.fromJson(key, await AbsSavable.loadJson(key));
  }

  Trackable.fromJson(String? key, Map<String, dynamic> json) {
    id = key;
    title = json['title'];
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'title': title,
      };
}
