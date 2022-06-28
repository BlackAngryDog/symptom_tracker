import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:symptom_tracker/model/abs_savable.dart';
import 'package:symptom_tracker/model/trackable.dart';

class DatabaseTools {
  //final DatabaseReference _timerRef =
  //    FirebaseDatabase.instance.ref().child('timers');

  void saveTracker(Trackable item) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("${item.endpoint}/${getUserID()}");
    if (item.id != null) {
      ref.update({
        item.id as String: item.toJson(),
      });
    } else {
      // TODO - CHECK IF TIMER WITH SAME NAME ALREADY IN DB
      // get where title in data?

      ref.push().set(item.toJson());
    }
  }

  Query getQuery(String endpoint) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("$endpoint/${getUserID()}");
    return ref;
  }

  Future<Trackable> getTrackable(String key) async {
    Query ref = FirebaseDatabase.instance.ref('trackers/${getUserID()}/$key');
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value == null) return Trackable();
    return Trackable.fromJson(
        key, event.snapshot.value as Map<dynamic, dynamic>);
  }

  String getUserID() {
    String uid = 'default';
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser?.uid != null) {
      uid = FirebaseAuth.instance.currentUser?.uid as String;
    }
    return uid;
  }
}
