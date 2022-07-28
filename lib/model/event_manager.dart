import 'dart:async';

import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';

class UpdateEvent {
  final String event;
  UpdateEvent(this.event);
}

class EventManager {
  static late EventManager instance;

  Trackable _selectedTarget;
  Tracker? _selectedTracker;

  static set selectedTarget(Trackable value) {
    instance._selectedTarget = value;
    instance.trackableController.add(UpdateEvent("Update_Target"));
  }

  static set selectedTracker(Tracker? value) {
    instance._selectedTracker = value;
    instance.trackableController.add(UpdateEvent("Update_Tracker"));
  }

  static Trackable get selectedTarget => instance._selectedTarget;
  static Tracker? get selectedTracker => instance._selectedTracker;

  StreamController<UpdateEvent> trackableController = StreamController<UpdateEvent>.broadcast();

  static Stream<UpdateEvent> get stream => instance.trackableController.stream;

  EventManager(this._selectedTarget) {
    // TODO - MAKE SINGLETON
    instance = this;
  }
}
