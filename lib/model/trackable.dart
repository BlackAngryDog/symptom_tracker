import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/track_option.dart';

import 'tracker.dart';

// Used to store details of thing bing tracked (a group of trackers)
class Trackable {
  // Trackable object to store tracked data
  String? userID;
  String? id;
  String? title;

  Tracker? _dietTracker;
  Tracker? _weightTracker;

  List<String> trackerIDs = [];
  List<TrackOption> trackOptions = [];
  List<Tracker> trackers = [];

  final List<DataLog> _log = [];
  List<DataLog> get log => _log;

  Trackable({this.title});

  // GET A DIET TRACKER FOR LOGGIN (STANDARD TRACKERS NEED FOR IMPLEMENTATION)
  Tracker getDietTracker() {
    if (_dietTracker != null) return _dietTracker as Tracker;

    _dietTracker = Tracker(
        id ?? '',
        TrackOption(
            title: 'Diet Tracker', trackType: 'diet', autoFill: AutoFill.last));
    return _dietTracker as Tracker;
  }

  Tracker getWeightTracker() {
    if (_weightTracker != null) return _weightTracker as Tracker;

    _weightTracker =
        trackers.firstWhere((element) => element.option.title == 'Weight ');
    return _weightTracker as Tracker;
  }

  Future<List<TrackOption>> getTrackOptions() async {
    trackOptions.clear();
    for (var tid in trackerIDs) {
      var option = await TrackOption.load(tid);
      trackOptions.add(option);
      trackers.add(Tracker(id ?? '', option));
    }

    return trackOptions;
    //return trackerIDs.map((e) => await TrackOption.getOption(e)).toList();
  }

  Future<List<DataLog>> getDataLogs(DateTime start, DateTime end) async {
    List<DataLog> logs = [];
    if (id == null) return logs;

    start = start.startOfDay;
    end = end.endOfDay;

    return await DataLog.getCollection(id ?? "Default")
        .where('time', isGreaterThanOrEqualTo: start)
        .where('time', isLessThanOrEqualTo: end)
        .get(const GetOptions(source: Source.serverAndCache))
        .then((data) {
      logs = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();

      return logs;
    }); // TODO - ADD ERROR
  }

  // PERSISTANCE

  Future save() async {
    CollectionReference collection = getCollection();
    if (id != null) {
      Map<dynamic, dynamic> map = toJson();
      collection
          .doc(id)
          .set(map)
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
    return FirebaseFirestore.instance
        .collection('users')
        .doc(DatabaseTools.getUserID())
        .collection('trackable');
  }

  static Future<Trackable> load(String key) async {
    final doc = getCollection().doc(key);

    return doc.get().then(
      (snapshot) async {
        var item =
            Trackable.fromJson(doc.id, snapshot.data() as Map<String, dynamic>);
        await item.getTrackOptions();
        return item;
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

    // set trackerIDs to json
    trackerIDs =
        json['trackerIDs'] != null ? List.from(json['trackerIDs']) : [];
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'trackerIDs': trackOptions
            .where((element) => element.id?.isNotEmpty == true)
            .map((e) => e.id)
            .toList(),
      };
}
