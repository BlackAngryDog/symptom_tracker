import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/tracker.dart';

// Used to store daily log information to be retrieved by date for user id
class TrackOption {
  String? id;
  String? title;
  String? trackType;
  // TODO - ADD TYPE

  TrackOption({this.id, this.title, this.trackType});

  static Future<List<TrackOption>> getOptions() async {
    return TrackOption.getCollection().get().then((data) {
      List<TrackOption> log = data.docs.map((doc) {
        return TrackOption.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return log;
    });
  }

  TrackOption save() {
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
          .then((value) => {id = value.id})
          .catchError((error) => print("Failed to add user: $error"));
    }

    return this;
  }

  static CollectionReference getCollection() {
    return FirebaseFirestore.instance.collection('users').doc(DatabaseTools.getUserID()).collection('trackOptions');
  }

  static Future<dynamic> load(String key) async {
    return TrackOption.fromJson(key, await AbsSavable.loadJson(key));
  }

  TrackOption.fromJson(String? key, Map<String, dynamic> json) {
    id = key;
    title = json['title'];
    trackType = json['trackType'];
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'trackType': trackType,
      };
}
