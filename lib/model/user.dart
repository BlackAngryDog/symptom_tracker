import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/abs_savable.dart';

// discribes the setup of the tracker and creates log entries
class UserVo {
  // Tracking data
  String? id;

  // tracker title (does this need to be unique in data?)
  String? name;
  String? role;

  String? selectedID;

  UserVo(this.name, this.role, {this.id});

  // PERSISTANCE
  /*
  Future save() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('users');

    if (id != null) {
      return await collection
          .doc(id)
          .set(toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      return await collection
          .add(toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
    return this;
  }

   */

  Future<UserVo> save() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('users');
    if (id != null) {
      await collection
          .doc(id)
          .set(toJson())
          .then((value) => print("User Saved"))
          .catchError((error) => print("Failed to save tracker: $error"));
    } else {
      await collection
          .add(toJson())
          .then((value) => {id = value.id})
          .catchError((error) => print("Failed to create tracker: $error"));
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
    selectedID = json['selectedID'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'role': role,
        'selectedID': selectedID,
      };
}
