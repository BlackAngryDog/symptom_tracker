import 'dart:convert';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/tracker.dart';

// Used to store daily log information to be retrieved by date for user id
class DataLog extends AbsSavable {
  String? id;
  String? title;

  DataLog() : super('datalogs');

  // How is are logs stored for retreaval and reading

  // DATE, TITLE, VALUE, TYPE OF DATA

  // update depending on type?
  void update() {}

  // PERSISTANCE
  static Future<dynamic> load(String key) async {
    return DataLog.fromJson(key, await AbsSavable.loadJson(key));
  }

  DataLog.fromJson(String? key, Map<dynamic, dynamic> json)
      : super('datalogs') {
    id = key;
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'title': title,
      };
}
