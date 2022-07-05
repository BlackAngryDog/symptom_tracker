import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderPage extends StatefulWidget {
  final Trackable _trackable;

  const CalenderPage(this._trackable, {Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  @override
  void initState() {
    super.initState();
    _getDataEvents();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text('history'),
      ),
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.schedule,
          scheduleViewSettings: ScheduleViewSettings(
              monthHeaderSettings: MonthHeaderSettings(height: 50)),
          dataSource: MeetingDataSource([]),
          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display
          // mode property
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ),
      ),
    );
  }

  List<DataLog> _dataLogs = [];

  void _getDataEvents() {
    var test = DataLog.getCollection(widget._trackable.id ?? "Default")
        .snapshots()
        .map((QuerySnapshot document) {
      var data = document.docs!;
    });

    var test2 = test
        .map((value) => DataLog.fromJson('', value as Map<String, dynamic>));

    //for (var i = 0; i < results.length; i++) {
    //  Map<String, dynamic> map = Map.from(results[i] as Map<String, dynamic>);
    //}
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<DataLog> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).time;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).time;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).title ?? "";
  }

  @override
  Color getColor(int index) {
    return const Color(0xFF0F8644);
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  DataLog _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final DataLog meetingData;
    if (meeting is DataLog) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
