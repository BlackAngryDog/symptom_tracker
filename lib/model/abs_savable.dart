import 'package:symptom_tracker/model/databaseTool.dart';

class ISavable {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }

  String? get id => null;
  String get endpoint => '';
}

abstract class AbsSavable {
  static String _endpoint = '';

  AbsSavable(String endpoint) {
    AbsSavable._endpoint = endpoint;
  }

  void save(String? id, Map<String, dynamic> json) {
    DatabaseTools.SaveItem(id, _endpoint, json);
  }

  String getEndpoint() {
    return _endpoint;
  }
}
