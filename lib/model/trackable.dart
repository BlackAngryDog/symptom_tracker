import 'dart:convert';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/data_log.dart';

import 'tracker.dart';

// Used to store details of thing bing tracked (a group of trackers)
class Trackable extends AbsSavable {
  // Trackable object to store tracked data
  String? id;

  String? title;

  List<Tracker> _trackers = [];
  List<Tracker> get trackers => _trackers;

  List<DataLog> _log = [];
  List<DataLog> get log => _log;

  Trackable() : super('trackables');

  /*
    Get log - between dates (retrieve all the information saved into the data logs )


   */
  //retrieve all the information saved into the data logs [from] [to]
  List<DataLog> getLog(DateTime from, DateTime to) {
    List<DataLog> list = <DataLog>{} as List<DataLog>;
    return list;
  }

  // when a tracker changes update the log ()
  void updateLog() {}

  // PERSISTANCE
  static Future<dynamic> load(String key) async {
    return Trackable.fromJson(key, await AbsSavable.loadJson(key));
  }

  Trackable.fromJson(String? key, Map<dynamic, dynamic> json)
      : super('trackables') {
    id = key;
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'title': title,
        'timers': jsonEncode(_trackers.map((entry) => "${entry.id}").toList()),
      };
}
