import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/pages/calender_page.dart';
import 'package:symptom_tracker/pages/chart_page.dart';
import 'package:symptom_tracker/pages/diet_options_page.dart';
import 'package:symptom_tracker/pages/trackable_selection_page.dart';
import 'package:symptom_tracker/pages/tracker_history.dart';
import 'package:symptom_tracker/pages/tracker_options_page.dart';
import 'package:symptom_tracker/popups/add_tracker_popup.dart';
import 'package:symptom_tracker/widgets/appbar_popup_menu_button.dart';
import 'package:symptom_tracker/widgets/bottom_tracker_panel.dart';
import 'package:symptom_tracker/widgets/tracker_week.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TrackerPage extends StatefulWidget {

  TrackerPage(_trackable, {Key? key}) : super(key: key) {
    EventManager(_trackable);
  }

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {

  late StreamSubscription trackerSubscription;

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    trackerSubscription = EventManager.stream.listen((event) {
      if (event.event == EventType.trackableChaned)
      {
        setState(() {});
      }
    });
  }

  void _addTrackerPopup(BuildContext ctx) {
    var value = TrackOption();
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: AddTracker(_addTracker, value),
            ),
          );
        });
  }

  void _addTracker(TrackOption value) {
    EventManager.selectedTarget.AddTrackOption(value);
  }

  void showHistory(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => TrackerHistoryPage(
                EventManager.selectedTarget,
              )),
    );
  }

  void showChart(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => ChartPage(
            EventManager.selectedTarget,
              )),
    );
  }

  void showCalendar(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => CalenderPage(
            EventManager.selectedTarget,
                calendarView: CalendarView.week,
              )),
    );
  }

  Future showDietOptions(BuildContext ctx) async {
    // SHOW FOOD LIST
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => const DietOptionsPage(),
      ),
    );
  }

  Future showTrackingOptions(BuildContext ctx) async {
    // SHOW FOOD LIST
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => TrackerOptionsPage(EventManager.selectedTarget),
      ),
    );
  }

  Future<void> showTrackableList(BuildContext ctx) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      ctx,
      MaterialPageRoute(builder: (ctx) => const TrackableSelectionPage()),
    );

    if (result != null) {
      EventManager.selectedTarget = result;
    }

  }

  void _showTrackerPanel(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: const BottomTrackerSelectionPanel(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        automaticallyImplyLeading: true,
        title: Text(EventManager.selectedTarget.title ?? "DOG"),
        actions: [
          IconButton(
              onPressed: () {
                showChart(context);
              },
              icon: const Icon(Icons.pie_chart)),
          IconButton(
              onPressed: () {
                showHistory(context);
              },
              icon: const Icon(Icons.remove_red_eye)),
          IconButton(
              onPressed: () {
                showCalendar(context);
              },
              icon: const Icon(Icons.calendar_month)),
          AppBarMenuButton({
            'Switch': () {
              showTrackableList(context);
            },
            'Logout': () {},
          })
        ],
      ),

      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).copyWith().size.height,
          child:  const Column(
            children: [
              Expanded(child: TrackerWeek()),
            ],
            //TrackerList(widget.trackable),
          ),


        ),
      ),
/*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTrackingOptions(context);
        },
        tooltip: 'Increment',
        mini: true,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,


 */
      bottomNavigationBar: BottomAppBar(
        notchMargin: 3,
        height: 60,
        elevation: 10,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {
                _showTrackerPanel(context);
              },
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {
                showTrackingOptions(context);
              },
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.rice_bowl_rounded),
              onPressed: () {
                showDietOptions(context);
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
