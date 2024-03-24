

import 'package:flutter/cupertino.dart';
import 'package:symptom_tracker/model/database_objects/track_option.dart';

class TrackerService{

}

class TrackerTypeVO{
  final String title;
  final TrackerTypes trackType;
  final String icon;
  final AutoFill autoFill;

  TrackerTypeVO({
    required this.title,
    required this.trackType,
    required this.icon,
    required this.autoFill,
  });
}

enum TrackerTypes { counter, quality, rating, value}//severity, diet, exercise, medication, mood}