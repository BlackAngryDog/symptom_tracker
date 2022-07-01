import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return;
    DatabaseReference ref = DatabaseTools.getRef(_endpoint);

    if (id != null) {
      ref.update({
        id: json,
      });
    } else {
      // TODO - CHECK IF TIMER WITH SAME NAME ALREADY IN DB
      // get where title in data?

      ref.push().set(json);
    }
  }

  static Future<Map<String, dynamic>> loadJson(String key) async {
    DatabaseReference ref = DatabaseTools.getRef(_endpoint);
    DatabaseEvent event = await ref.once();
    return event.snapshot.value == null ? <String, dynamic>{} : event.snapshot.value as Map<String, dynamic>;
  }

  String getEndpoint() {
    return _endpoint;
  }
}
