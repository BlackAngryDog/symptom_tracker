import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/model/user.dart';
import 'package:symptom_tracker/pages/calender_page.dart';
import 'package:symptom_tracker/pages/chart_page.dart';
import 'package:symptom_tracker/pages/diet_options_page.dart';
import 'package:symptom_tracker/pages/tracker_history.dart';
import 'package:symptom_tracker/pages/tracker_options_page.dart';
import 'package:symptom_tracker/widgets/add_tracker_popup.dart';
import 'package:symptom_tracker/widgets/appbar_popup_menu_button.dart';
import 'package:symptom_tracker/widgets/bottom_tracker_panel.dart';
import 'package:symptom_tracker/widgets/data_log_list.dart';
import 'package:symptom_tracker/widgets/info_header.dart';
import 'package:symptom_tracker/widgets/line_chart.dart';
import 'package:symptom_tracker/widgets/mini_trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/mini_trackers/diet_tracker.dart';
import 'package:symptom_tracker/widgets/tracker_info_panel.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';
import 'package:symptom_tracker/widgets/tracker_list.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:symptom_tracker/pages/trackable_selection_page.dart';

class TrackerPage extends StatelessWidget {
  Trackable trackable;
  TrackerPage(this.trackable, {Key? key}) : super(key: key) {
    EventManager(trackable);
  }

  //static StreamController<Trackable> trackableController = StreamController<Trackable>.broadcast();
  //static StreamController<Tracker> trackerController = StreamController<Tracker>.broadcast();

  void _addTrackerPopup(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: AddTracker(_addTracker),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addTracker(Tracker value) {
    // DatabaseTools.testFirestore();

    // setState(() {
    // TODO - CREATE A NEW TRACKER IN THE TRACKABLE (NEEDS POPUP FOR PARAMS)

    Tracker tracker = value;
    tracker.trackableID = trackable.id ?? 'default';
    // TODO - Switch to tracker options list update
    //tracker.save();
    //});
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
                trackable,
              )),
    );
  }

  void showCalendar(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => CalenderPage(
                trackable,
                calendarView: CalendarView.week,
              )),
    );
  }

  Future showDietOptions(BuildContext ctx) async {
    // SHOW FOOD LIST
    Tracker dietTracker = await trackable.getDietTracker();
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => DietOptionsPage(),
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

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    //if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    //ScaffoldMessenger.of(context)
    //  ..removeCurrentSnackBar()
    //  ..showSnackBar(SnackBar(content: Text('$result')));

    //setState(() {
    //_trackerInfoPanel..setTrackable(result);
    if (result != null) {
      EventManager.selectedTarget = result;
    }
    // trackable = result;
    //_bottomButtonPanel = BottomTrackerSelectionPanel(widget.trackable, setActiveTracker);
    // _selectedTracker = null;
    // });
  }

  void _showTrackerPanel(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: BottomTrackerSelectionPanel(),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  TrackerInfoPanel _trackerInfoPanel = TrackerInfoPanel();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print("build");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        automaticallyImplyLeading: true,
        title: Text(trackable.title ?? "DOG"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const InfoHeader(),
            _trackerInfoPanel,
          ],
          //TrackerList(widget.trackable),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTrackerPopup(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,

      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
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
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
