import 'dart:async';

import 'package:flutter/material.dart';
import 'package:symptom_tracker/managers/event_manager.dart';

import 'package:symptom_tracker/views/pages/calender_page.dart';
import 'package:symptom_tracker/views/pages/history/chart_page.dart';
import 'package:symptom_tracker/views/pages/diet_options_page.dart';
import 'package:symptom_tracker/views/pages/trackable_selection_page.dart';
import 'package:symptom_tracker/views/pages/tracker_history.dart';
import 'package:symptom_tracker/views/pages/tracker_options_page.dart';
import 'package:symptom_tracker/popups/add_note_popup.dart';

import 'package:symptom_tracker/views/widgets/header/appbar_popup_menu_button.dart';
import 'package:symptom_tracker/views/widgets/home/tracker_week.dart';
import 'package:symptom_tracker/views/widgets/log/data_timeline.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TrackerPage extends StatefulWidget {

  TrackerPage(trackable, {Key? key}) : super(key: key) {
    EventManager(trackable);
  }

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  var _selectedIndex = 0;
  late StreamSubscription trackerSubscription;
  var PageTitle = "Home";

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    trackerSubscription = EventManager.stream.listen((event) {
      if (event.event == EventType.trackableChanged)
      {
        setState(() {});
      }
    });
  }

  void _addNote(BuildContext ctx) {
  
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
              child: const AddNote(),
            ),
          );
        });
  }

  void showHistory(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => const TrackerHistoryPage()),
    );
  }

  void showChart(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => const ChartPage()),
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

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      PageTitle = index == 0 ? "Home" : index == 1 ? "Chart" : "Log";
      _selectedIndex = index;
    });
  }

  Widget _getPageContent(){
    switch(_selectedIndex) {
      case 0:
        return const TrackerWeek();
        break;
      case 1:
        return const ChartPage();
        break;
      case 2:
        return DataTimeLine(EventManager.selectedTarget);
        break;
      default:
        return const TrackerWeek();
        break;
    }
  }

  Future showOptions(BuildContext ctx) async {
    var selection = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).copyWith().size.width, MediaQuery.of(context).copyWith().size.height, 0.0, 0.0),
      items: <PopupMenuItem<String>>[
        const PopupMenuItem<String>(
            value: 'trackers',
            child: Text('Edit Trackers')),
        const PopupMenuItem<String>(
            value: 'diet',
            child: Text('Edit Diet')),
        const PopupMenuItem<String>(
            value: 'note',
            child: Text('Add Note')),
      ],
      elevation: 8.0,
    );

    switch(selection){
      case 'trackers':
        Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (context) => const TrackerOptionsPage()),
        );
        break;
      case 'diet':
        Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (context) => const DietOptionsPage()),
        );
        break;
      case 'note':
        _addNote(ctx);
        break;
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        automaticallyImplyLeading: true,

        title: Row(

          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Text("${EventManager.selectedTarget.title ?? 'DOG'}'s $PageTitle" )),
            AppBarMenuButton({
              'Switch': () {
                showTrackableList(context);
              },
              'Logout': () {},
            }),

          ],
        ),
      ),

      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).copyWith().size.height,
          child:  Column(
            children: [
              Expanded(child: _getPageContent()),
            ],
            //TrackerList(widget.trackable),
          ),


        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_addNote(context);
          showOptions(context);
        },
        tooltip: 'Increment',
        mini: true,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endContained,


      bottomNavigationBar: BottomAppBar(
        notchMargin: 3,
        height: 60,
        elevation: 10,
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,

          children: <Widget>[
            IconButton(
              tooltip: 'Week',
              icon: const Icon(Icons.home),
              color: _selectedIndex == 0 ? Colors.amber : Colors.black12,
              onPressed: () {
                _onItemTapped(0,context);
              },
            ),
            IconButton(
              tooltip: 'chart',
              icon: const Icon(Icons.pie_chart),
              color: _selectedIndex == 1 ? Colors.amber : Colors.black12,
              onPressed: () {
                _onItemTapped(1,context);
              },
            ),
            IconButton(
              tooltip: 'Log',
              icon: const Icon(Icons.remove_red_eye),
              color: _selectedIndex == 2 ? Colors.amber : Colors.black12,
              onPressed: () {
                _onItemTapped(2,context);
              },
            ),
            const SizedBox(width: 50),
            /*
            IconButton(

              tooltip: 'menu',
              icon: const Icon(Icons.menu),
              onPressed: () {
                showOptions(context);
              },
            ),
             */


          ],
        ),
      ),

      /*
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap:  (index)=>_onItemTapped(index, context),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
       */
    );
  }
}


