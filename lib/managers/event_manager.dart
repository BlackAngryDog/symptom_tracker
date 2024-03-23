import 'dart:async';

import 'package:collection/collection.dart';
import 'package:symptom_tracker/model/database_objects/track_option.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';

class UpdateEvent {
  final EventType event;
  Tracker? tracker;
  UpdateEvent(this.event, {this.tracker});
}

enum EventType {
  trackerChanged,
  targetChanged,
  trackerAdded, trackableChanged,
}

class EventManager {
  static final EventManager _instance = EventManager._internal();

  late Trackable _selectedTarget;
  Tracker? _selectedTracker;

  static Future<Trackable> loadTracker(String id) async{
    // TODO - Implement a Future to load tracker
    _instance._selectedTarget = await Trackable.load(id);
    await _instance._selectedTarget.getTrackOptions();
    dispatchUpdate(UpdateEvent(EventType.targetChanged));
    return _instance._selectedTarget;
  }


  static set selectedTarget(Trackable value) {
    _instance._selectedTracker = null;
    _instance._selectedTarget = value;
    // TODO - Implement a Future to assign selected target if needed
    dispatchUpdate(UpdateEvent(EventType.targetChanged));
  }

  static set selectedTracker(Tracker? value) {
    _instance._selectedTracker = value;
    dispatchUpdate(UpdateEvent(EventType.targetChanged));
  }

  static Trackable get selectedTarget => _instance._selectedTarget;
  static Tracker? get selectedTracker => _instance._selectedTracker;

  StreamController<UpdateEvent> trackableController =
      StreamController<UpdateEvent>.broadcast();

  static Stream<UpdateEvent> get stream => _instance.trackableController.stream;

  factory EventManager(Trackable tgt) {
    //instance._selectedTarget = _selectedTarget;
    selectedTarget = tgt;
    return _instance;
  }
  EventManager._internal();

  static void dispatchUpdate(UpdateEvent event) {
    _instance.trackableController.add(event);
  }
}
