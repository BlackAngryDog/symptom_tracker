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

  Trackable();

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

  // PERSISTANCE

  Trackable save() {
    CollectionReference collection = getCollection();
    if (id != null) {
      collection
          .doc(id)
          .set(toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      collection
          .add(toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return this;
  }

  static CollectionReference getCollection() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(DatabaseTools.getUserID())
        .collection('trackable');
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
