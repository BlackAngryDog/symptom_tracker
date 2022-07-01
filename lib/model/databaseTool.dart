import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/trackable.dart';

class DatabaseTools {
  //final DatabaseReference _timerRef =
  //    FirebaseDatabase.instance.ref().child('timers');

  static void testFirestore() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    CollectionReference collection =
        FirebaseFirestore.instance.collection(endpoint);

    dynamic snap = collection.doc(id).get();

    collection
        .add(json)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    final messageRef = FirebaseFirestore.instance
        .collection("rooms")
        .doc("roomA")
        .collection("messages");
    // ADDING SUBCOLLECTIONS
    messageRef.add({
      'full_name': 'test', // John Doe
      'company': 'company', // Stokes and Sons
      'age': 'age' // 42
    });

    /*FirebaseFirestore.instance
        .collection("$endpoint/${getUserID()}")
        //.where(FieldPath.documentId, whereIn: documentIds)
        .get()
        .then((value) => print("User Added"));

     */
  }

/*
    Future<Element> launchElement(){
      return new Future.value(true)
          .then((_) => getItems())
          .then((_) => innerDiv);
    }
*/

  static DatabaseReference getRef(String endpoint) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("$endpoint/${getUserID()}");
    return ref;
  }

  static String getUserID() {
    String uid = 'default';
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser?.uid != null) {
      uid = FirebaseAuth.instance.currentUser?.uid as String;
    }
    return uid;
  }

  DatabaseReference getQuery(String endpoint) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("$endpoint/${getUserID()}");
    return ref;
  }
}
