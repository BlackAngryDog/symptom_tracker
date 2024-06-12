import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/enums/tracker_enums.dart';
import 'package:symptom_tracker/model/database_objects/abs_savable.dart';
import 'package:symptom_tracker/services/database_service.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/extentions/extention_methods.dart';

// TODO - ADD AUTO FILL OPTIONS - Weight may need ideal or target but is that here? ??
enum AutoFill { initial, zero, last }

// Used to store daily log information to be retrieved by date for user id
class TrackOption extends AbsSavable<TrackOption>{

  String? title;
  late TrackerType trackType;
  String? icon;
  AutoFill? autoFill;

  TrackOption({this.title, this.trackType = TrackerType.counter, this.icon, this.autoFill, String? id}) : super(id:id);

  static Future<List<TrackOption>> getOptions() async {

    var data = await TrackOption.collection().get();
    var list = data.docs.map((doc) {
      var json = doc.data() as Map<String, dynamic>;
      // Check if the track type is valid
      var isValid = TrackerType.values.any((element) => element.toShortString() == json['trackType']);
      if (isValid) {
        return TrackOption.fromJson(
            doc.id, doc.data() as Map<String, dynamic>);
      }

      return null;
    }).toList().where((e) => e != null).map((e) => TrackOption()).toList();
    return list;

  }

  @override
  CollectionReference getCollection() {
      return TrackOption.collection();
  }

  static CollectionReference collection() =>
      FirebaseFirestore.instance
      .collection('users')
      .doc(DatabaseService.getUserID())
      .collection('trackOptions');

  static Future<TrackOption?> load(String key) async {
    if (key.isEmpty) return TrackOption();

    final doc = collection().doc(key);
    return doc.get().then((snapshot) {

      if (!snapshot.exists) {
        return null;
      }

      var json = snapshot.data() as Map<String, dynamic>;
      if (!TrackerType.values.any((element) => element.toShortString() == json['trackType'])) {
        return null;
      }

      return TrackOption.fromJson(
          doc.id, snapshot.data() as Map<String, dynamic>);
    }).catchError((error, stackTrace) => null);

  }

  TrackOption.fromJson(String? key, Map<String, dynamic> json) {
    id = key!.isEmpty
        ? json['id']
        : key; // TODO - LINK TRAKER OPTION TO DATA - LINK DATA LOGS TO OPTION
    title = json['title'];
    trackType = TrackerType.values.byName(json['trackType']);
    icon = json['icon'];
    autoFill = AutoFill.values.byName(json['autoFill'] ?? 'initial');
  }

  TrackOption.fromTracker(Tracker tracker) {
    id = tracker.option.id;
    title = tracker.option.title;
    trackType = tracker.option.trackType;
    icon = tracker.option.icon;
    autoFill = tracker.option.autoFill;
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'trackType': trackType.toShortString(),
    'icon': icon,
    'autoFill': autoFill?.toShortString(),
  };
}
