import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:symptom_tracker/model/database_objects/user.dart';

class DatabaseService {
  //final DatabaseReference _timerRef =
  //    FirebaseDatabase.instance.ref().child('timers');

  static Future<UserVo?> getUser() async {
    String uid = getUserID();
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      var snapshot = await doc.get();
      return UserVo.fromJson(doc.id, snapshot.data() as Map<String, dynamic>);
    } catch (error) {
      return null;
    }
  }
/*
  static void saveItem(ISavable item) {
    save(item.id, item.endpoint, item.toJson());
  }
*/
  static void save(String? id, CollectionReference collection, Map<String, dynamic> json) {
    var saveOperation = id != null ? collection.doc(id).set(json) : collection.add(json);
    saveOperation.catchError((error) => print('Failed to save data: $error'));
  }

  static String getUserID() {
    String uid = 'default';
    if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser?.uid != null) {
      uid = FirebaseAuth.instance.currentUser?.uid as String;
    }
    return uid;
  }

}
