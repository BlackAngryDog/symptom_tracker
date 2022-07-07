import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/tracker.dart';

// Used to store daily log information to be retrieved by date for user id
class DataLog {
  String? id;
  String? title;
  DateTime time;
  dynamic value;
  String? type;
  String trackableID;

  DataLog(this.trackableID, this.time,
      {this.id, this.title, this.value, this.type}) {}

  // How is are logs stored for retreaval and reading

  // DATE, TITLE, VALUE, TYPE OF DATA, NOTE/EVENT

  // update depending on type?
  void update() {}

  // PERSISTANCE

  DataLog save() {
    CollectionReference collection = getCollection(trackableID);
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

  static CollectionReference getCollection(String owner) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(DatabaseTools.getUserID())
        .collection('trackable')
        .doc(owner)
        .collection('datalogs');
  }

  static Future<dynamic> load(String key) async {
    return DataLog.fromJson(key, await AbsSavable.loadJson(key));
  }

  DataLog.fromJson(String? key, Map<String, dynamic> json)
      : trackableID = json['trackableID'],
        time = (json['time'] as Timestamp).toDate() {
    id = key;
    title = json['title'];
    value = json['value'];
    type = json['type'];
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'trackableID': trackableID,
        'title': title,
        'time': time,
        'value': value,
        'type': type,
      };
}
