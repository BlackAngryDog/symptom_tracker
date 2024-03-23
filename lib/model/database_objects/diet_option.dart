import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:symptom_tracker/model/database_objects/abs_savable.dart';
import 'package:symptom_tracker/services/database_service.dart';


// Used to store daily log information to be retrieved by date for user id
class DietOption extends AbsSavable<DietOption> {

  String? title;

  DietOption({this.title, String? id}) : super(id:id);


  DietOption.fromJson(String? key, Map<String, dynamic> json) {
    id = key;
    title = json['title'];
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
  };

  @override
  CollectionReference getCollection() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(DatabaseService.getUserID())
        .collection('dietOptions');
  }

}
