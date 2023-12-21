import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/databaseTool.dart';

// Used to store daily log information to be retrieved by date for user id
class DataLog {
  String? id;

  DateTime time;
  dynamic value;

  String optionID;

  DataLog(
    this.optionID,
    this.time, {
    this.id,
    this.value,
  });

  // How is are logs stored for retreaval and reading

  // DATE, TITLE, VALUE, TYPE OF DATA, NOTE/EVENT

  // update depending on type?
  void update() {}

  // PERSISTANCE

  DataLog save(String owner) {
    CollectionReference collection = getCollection(owner);
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

  static CollectionReference getCollection(String owner) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(DatabaseTools.getUserID())
        .collection('trackable')
        .doc(owner)
        .collection('datalogs');
  }

  DataLog.fromJson(String? key, Map<String, dynamic> json)
      : optionID = json['optionID'] ?? '',
        time = (json['time'] as Timestamp).toDate() {
    id = key;
    value = json['value'];
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'optionID': optionID,
        'time': time,
        'value': value,
      };
}
