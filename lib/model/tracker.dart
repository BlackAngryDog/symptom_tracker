import 'package:symptom_tracker/model/abs_savable.dart';

// discribes the setup of the tracker and creates log entries
class Tracker extends AbsSavable {
  // Tracking data
  String? id;

  // tracker title (does this need to be unique in data?)
  String? title;
  String? userID;
  String? trackableID;
  String? type;

  Tracker({this.title, this.type}) : super('trackers') {
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

  static Future<Tracker> load(String key) async {
    return Tracker.fromJson(key, await AbsSavable.loadJson(key));
  }

  Tracker.fromJson(String? key, Map<String, dynamic> json)
      : super('trackables') {
    id = key;
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userID': userID,
        'title': title,
        'type': type,
      };
}
