import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/enums/tracker_enums.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';
import 'package:symptom_tracker/model/database_objects/abs_savable.dart';
import 'package:symptom_tracker/model/database_objects/data_log.dart';
import 'package:symptom_tracker/model/database_objects/track_option.dart';
import 'package:symptom_tracker/services/database_service.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:collection/collection.dart';

// Used to store details of thing bing tracked (a group of trackers)
class Trackable extends AbsSavable<Trackable>{
  // Trackable object to store tracked data
  String? userID;
  String? title;

  List<String> _trackerIDs = [];
  final List<TrackOption> _trackOptions = [];
  final List<Tracker> _trackers = [];

  final List<DataLog> _log = [];
  List<DataLog> get log => _log;

  Trackable({this.title, String? id}) : super(id:id);

  Future loadDefaultTrackers(List<TrackOption> options) async {
    // setup default trackers, wright, diet, notes and events

    var dataList = await TrackOption.getOptions();
    var options = await getTrackOptions();
    bool changed = false;

    changed = await addDefaultTrackOption(dataList, 'Weight', TrackerType.weight, AutoFill.last) ? true :  changed;
    changed = await addDefaultTrackOption(dataList, 'Diet Tracker', TrackerType.diet, AutoFill.last)? true :  changed;
    changed = await addDefaultTrackOption(dataList, 'Notes', TrackerType.note, AutoFill.last)? true : changed;
    changed = await addDefaultTrackOption(dataList, 'Events', TrackerType.event, AutoFill.last)? true :  changed;

    if (changed) {
     // var trackerIds = _trackOptions.map((e) => e.id).toList();
      saveTrackIDs(_trackerIDs);
    }
  }

  /// Add a default track option to the trackable if no option exists
  Future<bool> addDefaultTrackOption(List<TrackOption> dataList, String title, TrackerType trackType, AutoFill autoFill) async {

    var options = await getTrackOptions();

    if (!options.any((x) => x.trackType == trackType)) {

      // Get this option from the database
      var option = dataList.firstWhereOrNull((x) => x.trackType == trackType);

      // Add database entry if required
      if (option == null){
        option = TrackOption(title: title, trackType: trackType, autoFill: autoFill);
        await option.save();
      }

      // Assign to Trackable
      await addTrackOption(option);
      return true;
    }

    return false;
  }

  Future addTrackOption(TrackOption option) async {

    if (option.id == null || _trackOptions.any((current) => current.id == option.id))  return;
    // clear trackers as need to refresh
    _trackers.clear();

    // Add ID and option to list
    _trackerIDs.add(option.id??"");
    _trackOptions.add(option);

    // Fire event to update observers
    EventManager.dispatchUpdate(UpdateEvent(EventType.trackerAdded));
  }

  Future saveTrackIDs(List<String> trackerIds) async {
    _trackOptions.clear();
    _trackers.clear();
    _trackerIDs = trackerIds;
    save();
  }

  Future<List<TrackOption>> getTrackOptions() async {
    if (_trackOptions.isNotEmpty) return _trackOptions;

    _trackers.clear();
    for (var tid in _trackerIDs) {
      var option = await TrackOption.load(tid);
      if (option == null) continue;
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

  Tracker? getTracker(TrackerType type) {
    return _trackers.firstWhereOrNull((x) => x.option.trackType == type);
  }

  Future<List<DataLog>> getDataLogs(DateTime start, DateTime end) async {
    List<DataLog> logs = [];
    if (id == null) return logs;

    start = start.startOfDay;
    end = end.endOfDay;

    return await DataLog.collection(id!)
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

  @override
  CollectionReference getCollection() {
    return Trackable.collection();
  }

  static CollectionReference collection() =>
    FirebaseFirestore.instance
      .collection('users')
      .doc(DatabaseService.getUserID())
      .collection('trackable');


  static Future<Trackable> load(String key) async {
    final doc = collection().doc(key);

    return doc.get().then(
      (snapshot) async {
        var item =
            Trackable.fromJson(doc.id, snapshot.data() as Map<String, dynamic>);
        await item.loadDefaultTrackers(await item.getTrackOptions());

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
    _trackerIDs = json['trackerIDs'] != null ? List.from(json['trackerIDs']) : [];


  }

  @override
  Map<String, dynamic> toJson() =>
    {
      'title': title,
      'trackerIDs': _trackerIDs,
    };


}
