import 'package:symptom_tracker/model/abs_savable.dart';

// discribes the setup of the tracker and creates log entries
class Tracker extends AbsSavable {
  // Tracking data
  String? id;

  // tracker title (does this need to be unique in data?)
  String? title;

  Tracker() : super('trackers');

  // TYPE - counter, quality, duration, value

  // VALUE -THIS IS NOT SAVED HERE AS THAT IS FOR THE LOG!

  // set/update log for today for this tracker...
  void updateLog() {}

  // get data from logs for day ?
  void readLog() {}

  // PERSISTANCE

  static Future<Tracker> load(String key) async {
    return Tracker.fromJson(key, await AbsSavable.loadJson(key));
  }

  Tracker.fromJson(String? key, Map<dynamic, dynamic> json) : super('trackables') {
    id = key;
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'title': title,
      };
}
