import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';

// discribes the setup of the tracker and creates log entries
class UserVo {
  // Tracking data
  String? id;

  // tracker title (does this need to be unique in data?)
  String? name;
  String? role;

  UserVo(this.name, this.role, {this.id});

  // PERSISTANCE
  UserVo save() {
    CollectionReference collection = FirebaseFirestore.instance.collection('users');

    if (id != null) {
      collection.doc(id).set(toJson()).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
    } else {
      collection.add(toJson()).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
    }

    return this;
  }

  static Future<UserVo> load(String key) async {
    return UserVo.fromJson(key, await AbsSavable.loadJson(key));
  }

  UserVo.fromJson(String? key, Map<String, dynamic> json) : super() {
    id = key;
    name = json['name'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'role': role,
      };
}
