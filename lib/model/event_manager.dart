import 'dart:async';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:collection/collection.dart';

class UpdateEvent {
  final String event;
  UpdateEvent(this.event);
}

class EventManager {
  static final EventManager _instance = EventManager._internal();

  late Trackable _selectedTarget;
  Tracker? _selectedTracker;

  static set selectedTarget(Trackable value) {
    _instance._selectedTracker = null;
    _instance._selectedTarget = value;
    TrackOption? initialTrackerOption = _instance._selectedTarget.trackers.firstOrNull;
    if (initialTrackerOption != null)
      _instance._selectedTracker = Tracker.fromTrackOption(value.id ?? '', initialTrackerOption);
    dispatchUpdate();
  }

  static set selectedTracker(Tracker? value) {
    _instance._selectedTracker = value;
    dispatchUpdate();
  }

  static Trackable get selectedTarget => _instance._selectedTarget;
  static Tracker? get selectedTracker => _instance._selectedTracker;

  StreamController<UpdateEvent> trackableController = StreamController<UpdateEvent>.broadcast();

  static Stream<UpdateEvent> get stream => _instance.trackableController.stream;

  factory EventManager(Trackable _selectedTarget) {
    //instance._selectedTarget = _selectedTarget;
    selectedTarget = _selectedTarget;
    return _instance;
  }
  EventManager._internal();

  static void dispatchUpdate() {
    _instance.trackableController.add(UpdateEvent("Update_Tracker"));
  }
}