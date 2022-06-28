import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AbsSavable {
  AbsSavable();

  String getUserID() {
    String uid = 'default';
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser?.uid != null) {
      uid = FirebaseAuth.instance.currentUser?.uid as String;
    }
    return uid;
  }

  void save(String? id, String endpoint, Map<String, Object?> json) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("$endpoint/${getUserID()}");
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
}
