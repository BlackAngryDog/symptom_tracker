import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/database_objects/abs_savable.dart';


// discribes the setup of the tracker and creates log entries
class UserVo  extends AbsSavable<UserVo>{

  // tracker title (does this need to be unique in data?)
  String? name;
  String? role;

  String? selectedID;

  UserVo(this.name, this.role, {String? id}): super(id: id);

  @override
  CollectionReference getCollection() {
    return UserVo.collection();
  }

  static CollectionReference collection() {
    return FirebaseFirestore.instance.collection('users');
  }

  static Future<UserVo> load(String key) async {
    final doc = collection().doc(key);

    return doc
        .get()
        .then(
          (snapshot) => UserVo.fromJson(doc.id, snapshot.data() as Map<String, dynamic>),
        )
        .catchError(
          (error, stackTrace) => UserVo("NONE", 'None'),
        );
  }

  UserVo.fromJson(String? key, Map<String, dynamic> json) {
    id = key;
    name = json['name'];
    role = json['role'];
    selectedID = json['selectedID'];
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'role': role,
        'selectedID': selectedID,
      };
}
