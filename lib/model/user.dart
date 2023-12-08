import 'package:cloud_firestore/cloud_firestore.dart';


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

  static CollectionReference getCollection() {
    return FirebaseFirestore.instance.collection('users');
  }

  Future<UserVo> save() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('users');
    if (id != null) {
      await collection
          .doc(id)
          .set(toJson())
          .then((value) => print("User Saved"))
          .catchError((error) => print("Failed to save user: $error"));
    } else {
      await collection
          .add(toJson())
          .then((value) => {id = value.id})
          .catchError((error) => print("Failed to create user: $error"));
    }
    return this;
  }

  static Future<UserVo> load(String key) async {
    final doc = getCollection().doc(key);

    return doc
        .get()
        .then(
          (snapshot) => UserVo.fromJson(doc.id, snapshot.data() as Map<String, dynamic>),
        )
        .catchError(
          (error, stackTrace) => UserVo("NONE", 'None'),
        );
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
