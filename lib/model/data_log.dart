import 'dart:convert';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/tracker.dart';

// Used to store daily log information to be retrieved by date for user id
class DataLog extends AbsSavable {
  String? id;
  String? title;
  DateTime? time;
  String? value;
  String? type;

  DataLog({this.id, this.title, this.time, this.value, this.type})
      : super('datalogs');

  // How is are logs stored for retreaval and reading

  // DATE, TITLE, VALUE, TYPE OF DATA, NOTE/EVENT

  // update depending on type?
  void update() {}

  // PERSISTANCE
  static Future<dynamic> load(String key) async {
    return DataLog.fromJson(key, await AbsSavable.loadJson(key));
  }

  DataLog.fromJson(String? key, Map<dynamic, dynamic> json)
      : super('datalogs') {
    id = key;
    title = json['title'];
    time = DateTime.fromMicrosecondsSinceEpoch(json['time'] ?? 0);
    value = json['value'];
    type = json['type'];
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'title': title,
        'time': time?.microsecondsSinceEpoch.toString(),
        'value': value,
        'type': type,
      };
}
