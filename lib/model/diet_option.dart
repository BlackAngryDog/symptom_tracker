import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/tracker.dart';

// Used to store daily log information to be retrieved by date for user id
class DietOption {
  String? id;
  String? title;

  DietOption({this.id, this.title}) {}

  DietOption save() {
    CollectionReference collection = getCollection();
    if (id != null) {
      collection.doc(id).set(toJson()).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
    } else {
      collection.add(toJson()).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
    }

    return this;
  }

  static CollectionReference getCollection() {
    return FirebaseFirestore.instance.collection('users').doc(DatabaseTools.getUserID()).collection('dietOptions');
  }

  static Future<dynamic> load(String key) async {
    return DietOption.fromJson(key, await AbsSavable.loadJson(key));
  }

  DietOption.fromJson(String? key, Map<String, dynamic> json) {
    id = key;
    title = json['title'];
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'title': title,
      };
}
