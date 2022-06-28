import 'package:symptom_tracker/model/abs_savable.dart';

class Tracker extends AbsSavable {
  // Tracking data
  String? id;
  String? endpoint = 'tracker/';
  String? title;

  Tracker();

  // PERSISTANCE
  Tracker.fromJson(String? key, Map<dynamic, dynamic> json) : id = key;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'title': title,
      };
}
