import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/tracker.dart';

// Used to store daily log information to be retrieved by date for user id
class TrackOption {
  String? id;
  String? title;
  String? trackType;
  String? icon;

  TrackOption({this.id, this.title, this.trackType, this.icon});

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
    return FirebaseFirestore.instance
        .collection('users')
        .doc(DatabaseTools.getUserID())
        .collection('trackOptions');
  }

  static Future<TrackOption> load(String key) async {
    final doc = getCollection().doc(key);

    return doc
        .get()
        .then(
          (snapshot) => TrackOption.fromJson(
              doc.id, snapshot.data() as Map<String, dynamic>),
        )
        .catchError(
          (error, stackTrace) => TrackOption(),
        );
  }

  TrackOption.fromJson(String? key, Map<String, dynamic> json) {
    id =  key!.isEmpty ? json['id'] : key; // TODO - LINK TRAKER OPTION TO DATA - LINK DATA LOGS TO OPTION
    title = json['title'];
    trackType = json['trackType'];
    icon = json['icon'];
  }

  TrackOption.fromTracker(Tracker tracker) {
    id = tracker.option.id;
    title = tracker.option.title;
    trackType = tracker.option.trackType;
    icon = tracker.option.icon;
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'trackType': trackType,
        'icon': icon,
      };
}
