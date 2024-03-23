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
    } catch (error) {
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
