import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/databaseTool.dart';

// discribes the setup of the tracker and creates log entries
class Tracker {
  // Tracking data
  String? id;

  // tracker title (does this need to be unique in data?)
  String? title;
  String? userID;
  String trackableID;
  String? type;

  Tracker(this.trackableID, {this.title, this.type}) {
    readLog();
  }

  // TYPE - counter, quality, duration, value

  // VALUE -THIS IS NOT SAVED HERE AS THAT IS FOR THE LOG!

  // set/update log for today for this tracker...
  void updateLog() {}

  // get data from logs for day ?
  void readLog() {
    // Load data log for this tracker id
  }

  // PERSISTANCE

  Tracker save() {
    CollectionReference collection = getCollection(trackableID);
    if (id != null) {
      collection.doc(id).set(toJson()).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
    } else {
      collection.add(toJson()).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
    }

    return this;
  }

  static CollectionReference getCollection(String owner) {
    return FirebaseFirestore.instance.collection('users').doc(DatabaseTools.getUserID()).collection('trackable').doc(owner).collection('trackers');
  }

  static Future<Tracker> load(String key) async {
    return Tracker.fromJson(key, await AbsSavable.loadJson(key));
  }

  Tracker.fromJson(String? key, Map<String, dynamic> json) : trackableID = json['trackableID'] {
    id = key;
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'trackableID': trackableID,
        'title': title,
        'type': type,
      };
}
