import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:symptom_tracker/services/database_service.dart';
import 'package:collection/src/iterable_extensions.dart';

abstract class ISavable {
  CollectionReference getCollection();
}

abstract class AbsSavable<T> implements ISavable{

  String? id;
  AbsSavable({this.id});

  T save() {
    try {
      id != null
          ? getCollection().doc(id).set(toJson())
          : getCollection().add(toJson()).then((value) => {id = value.id});
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
