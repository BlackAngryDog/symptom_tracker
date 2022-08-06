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
  static late EventManager instance;

  Trackable _selectedTarget;
  Tracker? _selectedTracker;

  static set selectedTarget(Trackable value) {
    instance._selectedTracker = null;
    instance._selectedTarget = value;
    TrackOption? initialTrackerOption = instance._selectedTarget.trackers.firstOrNull;
    if (initialTrackerOption != null) instance._selectedTracker = Tracker.fromTrackOption(value.id ?? '', initialTrackerOption);
    dispatchUpdate();
  }

  static set selectedTracker(Tracker? value) {
    instance._selectedTracker = value;
    dispatchUpdate();
  }

  static Trackable get selectedTarget => instance._selectedTarget;
  static Tracker? get selectedTracker => instance._selectedTracker;

  StreamController<UpdateEvent> trackableController = StreamController<UpdateEvent>.broadcast();

  static Stream<UpdateEvent> get stream => instance.trackableController.stream;

  EventManager(this._selectedTarget) {
    // TODO - MAKE SINGLETON

    instance = this;
    selectedTarget = _selectedTarget;
  }

  static void dispatchUpdate() {
    instance.trackableController.add(UpdateEvent("Update_Tracker"));
  }
}
