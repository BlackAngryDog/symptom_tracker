

import 'package:symptom_tracker/enums/tracker_enums.dart';
import 'package:symptom_tracker/model/database_objects/track_option.dart';

class TrackerService{

}

class TrackerTypeVO{
  final String title;
  final TrackerType trackType;
  final String icon;
  final AutoFill autoFill;

  TrackerTypeVO({
    required this.title,
    required this.trackType,
    required this.icon,
    required this.autoFill,
  });
}