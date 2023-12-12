import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderPage extends StatefulWidget {
  final Trackable _trackable;
  final CalendarView? calendarView;

  const CalenderPage(this._trackable, {Key? key, this.calendarView})
      : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  late MeetingDataSource source;

  @override
  void initState() {
    super.initState();
    source = MeetingDataSource([]);
    //_getDataEvents();
  }

  void showDayView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CalenderPage(
                widget._trackable,
                calendarView: CalendarView.day,
              )),
    );
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
        title: const Text('history'),
      ),
      body: SafeArea(
        child: SfCalendar(
          view: widget.calendarView ?? CalendarView.month,
          scheduleViewSettings: const ScheduleViewSettings(
              monthHeaderSettings: MonthHeaderSettings(height: 50)),
          dataSource: source,
          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display
          // mode property
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          onViewChanged: (details) {
            DateTime start = details.visibleDates.first;
            DateTime end = details.visibleDates.last;
            print("date change events");
            _getDataEvents(start, end);
          },
          onSelectionChanged: (tapped) {
            print("date tapped ${tapped.resource.toString()}");
          },
          onTap: (CalendarTapDetails details) {
            // DateTime date = details.date!;
            //dynamic appointments = details.appointments;
            //CalendarElement view = details.targetElement;
            //print("date tapped ${appointments.toString()}");
            if (widget.calendarView != CalendarView.day) showDayView(context);
          },
        ),
      ),
    );
  }

  Future<List<DataLog>> _getDataEvents(DateTime start, DateTime end) async {
    List<DataLog> logs = [];

    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day, 11, 59, 59);

    await DataLog.getCollection(widget._trackable.id ?? "Default")
        .where('time', isGreaterThanOrEqualTo: start)
        .where('time', isLessThanOrEqualTo: end)
        .get(const GetOptions(source: Source.serverAndCache))
        .then((data) {
      logs = data.docs.map((doc) {
        return DataLog.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      setState(() {
        source = MeetingDataSource(logs);
      });
      print("LOADED DATA $start to $end cound is ${logs.length}");
      return logs;
    }); // TODO - ADD ERROR
    return logs;
  }

}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<DataLog> source) {
    // TODO - CONDENSE EVENTS OF SAVE TYPE ?
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).time;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).time.add(const Duration(hours: 1));
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).title ?? "";
  }

  @override
  Color getColor(int index) {
    // TODO - SWITCH EVENT FOR COLOUR
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
