import 'dart:async';

import 'package:collection/collection.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';

class UpdateEvent {
  final EventType event;
  Tracker? tracker;
  UpdateEvent(this.event, {this.tracker});
}

enum EventType {
  trackerChanged,
  targetChanged,
  trackerAdded, trackableChaned,
}

class EventManager {
  static final EventManager _instance = EventManager._internal();

  late Trackable _selectedTarget;
  Tracker? _selectedTracker;

  static set selectedTarget(Trackable value) {
    _instance._selectedTracker = null;
    _instance._selectedTarget = value;
    TrackOption? initialTrackerOption =
        _instance._selectedTarget.trackOptions.firstOrNull;
    if (initialTrackerOption != null) {
      _instance._selectedTracker =
          Tracker.fromTrackOption(value.id ?? '', initialTrackerOption);
    }
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
