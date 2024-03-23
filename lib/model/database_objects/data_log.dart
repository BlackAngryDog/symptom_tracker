import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/database_objects/abs_savable.dart';
import 'package:symptom_tracker/services/database_service.dart';
import 'package:symptom_tracker/managers/event_manager.dart';

// Used to store daily log information to be retrieved by date for user id
class DataLog extends AbsSavable<DataLog>{
  DateTime time;
  dynamic value;

  String optionID;

  DataLog(
    this.optionID,
    this.time, {
    this.value,
    String? id
  });

  @override
  CollectionReference getCollection() {
    return DataLog.collection(EventManager.selectedTarget.id!);
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'optionID': optionID,
        'time': time,
        'value': value,
      };

  DataLog.fromJson(String? key, Map<String, dynamic> json)
      : optionID = json['optionID'] ?? '',
        time = (json['time'] as Timestamp).toDate() {
    id = key;
    value = json['value'];
  }

  static CollectionReference collection(String owner) =>
      FirebaseFirestore.instance
      .collection('users')
      .doc(DatabaseService.getUserID())
      .collection('trackable')
      .doc(owner)
      .collection('datalogs');
}
