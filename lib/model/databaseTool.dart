import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/trackable.dart';

class DatabaseTools {
  //final DatabaseReference _timerRef =
  //    FirebaseDatabase.instance.ref().child('timers');

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
}
