import 'dart:convert';
import 'package:symptom_tracker/model/abs_savable.dart';

import 'tracker.dart';

class Trackable extends AbsSavable {
  // Trackable object to store tracked data
  String? id;
  String? endpoint = 'trackables/';
  String? title;

  List<Tracker> _trackers = [];
  List<Tracker> get trackers => _trackers;

  Trackable();

  // PERSISTANCE
  Trackable.fromJson(String? key, Map<dynamic, dynamic> json)
      : id = key,
        title = json['title'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'title': title,
        'timers': jsonEncode(_trackers.map((entry) => "${entry.id}").toList()),
      };
}
