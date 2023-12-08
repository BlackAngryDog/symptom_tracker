import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/user.dart';

class DatabaseTools {
  //final DatabaseReference _timerRef =
  //    FirebaseDatabase.instance.ref().child('timers');

  static Future<UserVo> getUser() async {
    String uid = getUserID();

    final doc = FirebaseFirestore.instance.collection('users').doc(uid);

    return doc
        .get()
        .then(
          (snapshot) => UserVo.fromJson(doc.id, snapshot.data() as Map<String, dynamic>),
        )
        .catchError(
          (error, stackTrace) => UserVo("Dan", 'admin', id: uid).save(),
        );
  }

  static save(ISavable item) {
    CollectionReference collection = FirebaseFirestore.instance.collection(item.endpoint);

    if (item.id != null) {
      collection
          .doc(item.id)
          .set(item.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      return;
    }

    collection
        .add(item.toJson())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    return;
  }

  static void testFirestore() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .add({
          'full_name': 'test', // John Doe
          'company': 'company', // Stokes and Sons
          'age': 'age' // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static void SaveItem(String? id, String endpoint, Map<String, dynamic> json) {
    CollectionReference collection = FirebaseFirestore.instance.collection(endpoint);

    if (id != null) {
      collection
          .doc(id)
          .set(json)
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      return;
    }

    collection
        .add(json)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    return;
  }

/*
    Future<Element> launchElement(){
      return new Future.value(true)
          .then((_) => getItems())
          .then((_) => innerDiv);
    }
*/

  static DatabaseReference getRef(String endpoint) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("$endpoint/${getUserID()}");
    return ref;
  }

  static String getUserID() {
    String uid = 'default';
    if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser?.uid != null) {
      uid = FirebaseAuth.instance.currentUser?.uid as String;
    }
    return uid;
  }

  DatabaseReference getQuery(String endpoint) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("$endpoint/${getUserID()}");
    return ref;
  }
}
