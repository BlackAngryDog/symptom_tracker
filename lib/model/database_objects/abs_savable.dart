import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class ISavable {
  CollectionReference getCollection();
}

abstract class AbsSavable<T> implements ISavable{

  String? id;
  AbsSavable({this.id});

  Future<T> save() async {
    try {
      if(id != null) {
        getCollection().doc(id).set(toJson());
      }else {
        var value = await getCollection().add(toJson()); //.then((value) => {id = value.id});
        id  = value.id;
      }
    } on Exception catch (e) {
      // Anything else that is an exception
      print('Unknown exception: $e');
      rethrow;
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
      rethrow;
    }
    return this as T;
  }

  @required
  Map<String, dynamic> toJson() =>
      throw UnimplementedError();

  @required
  @override
  CollectionReference getCollection() =>
      throw UnimplementedError();

  @required
  static CollectionReference collection() =>
      throw UnimplementedError();
}
