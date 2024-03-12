import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/event_manager.dart';
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

  List<String> _trackerIDs = [];
  List<TrackOption> _trackOptions = [];
  List<Tracker> _trackers = [];

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
        _trackers.where((element) => element.option.title == 'Weight ').firstOrNull??
            Tracker(id ?? '', TrackOption(title: 'Weight', trackType: 'weight', autoFill: AutoFill.last));

    return _weightTracker as Tracker;
  }

  Future AddTrackOption(TrackOption option) async {

    if (option.id == null || _trackOptions.any((current) => current.id == option.id))  return;
    // clear trackers as need to refresh
    _trackers.clear();

    // Add ID and option to list
    _trackerIDs.add(option.id??"");
    _trackOptions.add(option);

    // Fire event to update observers
    EventManager.dispatchUpdate(UpdateEvent(EventType.trackerAdded));
  }

  /*
  Future loadTrackOptions(List<String> trackerIds) async {
    _trackOptions.clear();
    _trackers.clear();
    _trackerIDs = trackerIds;

    for (var tid in trackerIds) {
      var option = await TrackOption.load(tid);
      _trackOptions.add(option);
    }
    EventManager.dispatchUpdate(UpdateEvent(EventType.trackerAdded));
  }
  */

  Future saveTrackIDs(List<String> trackerIds) async {
    _trackOptions.clear();
    _trackers.clear();
    _trackerIDs = trackerIds;
    await save();
  }

  Future<List<TrackOption>> getTrackOptions() async {
    if (_trackOptions.isNotEmpty) return _trackOptions;

    _trackers.clear();
    for (var tid in _trackerIDs) {
      var option = await TrackOption.load(tid);
      _trackOptions.add(option);
      _trackers.add(Tracker(id ?? '', option));
    }

    return _trackOptions;
  }

  List<Tracker> getTrackers() {
    if (_trackers.isNotEmpty) return _trackers;

    for (var option in _trackOptions) {
      _trackers.add(Tracker(id ?? '', option));
    }
    return _trackers;
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
    _trackerIDs = json['trackerIDs'] != null ? List.from(json['trackerIDs']) : [];
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'trackerIDs': _trackerIDs,
      };
}
