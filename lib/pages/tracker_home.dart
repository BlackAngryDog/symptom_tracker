import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/model/user.dart';
import 'package:symptom_tracker/pages/calender_page.dart';
import 'package:symptom_tracker/pages/chart_page.dart';
import 'package:symptom_tracker/pages/tracker_history.dart';
import 'package:symptom_tracker/widgets/add_tracker_popup.dart';
import 'package:symptom_tracker/widgets/appbar_popup_menu_button.dart';
import 'package:symptom_tracker/widgets/bottom_tracker_panel.dart';
import 'package:symptom_tracker/widgets/data_log_list.dart';
import 'package:symptom_tracker/widgets/line_chart.dart';
import 'package:symptom_tracker/widgets/mini_trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/mini_trackers/diet_tracker.dart';
import 'package:symptom_tracker/widgets/tracker_info_panel.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';
import 'package:symptom_tracker/widgets/tracker_list.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:symptom_tracker/pages/trackable_selection_page.dart';

class TrackerPage extends StatefulWidget {
  Trackable trackable;
  TrackerPage(this.trackable, {Key? key}) : super(key: key);

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  bool _showBottomPanel = false;

  late Widget _bottomButtonPanel;

  @override
  void initState() {
    super.initState();
    print("init");
    _bottomButtonPanel = BottomTrackerSelectionPanel(widget.trackable, setActiveTracker);
    // GET USER ID
  }

  @override
  void activate() {
    super.activate();
    print("activeted");
    // GET USER ID
  }

  void _startAddTracker(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: Container(
              height: 200,
              color: Colors.amber,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Modal BottomSheet'),
                    ElevatedButton(
                      child: const Text('Close BottomSheet'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

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

    setState(() {
      // TODO - CREATE A NEW TRACKER IN THE TRACKABLE (NEEDS POPUP FOR PARAMS)

      Tracker tracker = value;
      tracker.trackableID = widget.trackable.id ?? 'default';
      tracker.save();
    });
  }

  void showHistory(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => TrackerHistoryPage(
                widget.trackable,
              )),
    );
  }

  void showChart(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => ChartPage(
                widget.trackable,
              )),
    );
  }

  void showCalendar(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => CalenderPage(
                widget.trackable,
                calendarView: CalendarView.week,
              )),
    );
  }

  Future<void> showTrackableList(BuildContext ctx) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TrackableSelectionPage()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    //ScaffoldMessenger.of(context)
    //  ..removeCurrentSnackBar()
    //  ..showSnackBar(SnackBar(content: Text('$result')));

    setState(() {
      widget.trackable = result;
      _bottomButtonPanel = BottomTrackerSelectionPanel(widget.trackable, setActiveTracker);
      _selectedTracker = null;
      _showBottomPanel = false;
    });
  }

  Tracker? _selectedTracker;
  void setActiveTracker(Tracker? tracker) {
    setState(() {
      _selectedTracker = tracker;
      _showBottomPanel = false;
    });
  }

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
        title: Text(widget.trackable.title ?? "DOG"),
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            // Title Text
            // THE FIVE TESTS
            // DRINKING, POO OK, WEIGHT OK, HAPPY, EATING OK

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.orangeAccent,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).copyWith().size.width,
                                  child: Text(
                                    widget.trackable.title ?? "DOG",
                                    style: Theme.of(context).textTheme.headline2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        width: MediaQuery.of(context).copyWith().size.width,
                        bottom: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //MiniCountTracker(Tracker('default')),
                            //MiniCountTracker(Tracker('default')),
                            //MiniCountTracker(Tracker('default')),
                          ],
                        ),
                      ),
                      Positioned(
                        //width: MediaQuery.of(context).copyWith().size.width,
                        top: 10,
                        left: 10,
                        child: CircleAvatar(
                          minRadius: 30,
                          backgroundColor: Colors.grey.shade800,
                          child: const FaIcon(
                            FontAwesomeIcons.dog,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                MiniCountTracker(Tracker(widget.trackable.id ?? "default", title: 'Poo Count', type: 'counter')),
                MiniDietTracker(Tracker(widget.trackable.id ?? "default", title: 'Diet', type: 'diet')),
                MiniCountTracker(Tracker(widget.trackable.id ?? "default", title: 'Weight', type: 'value')),
              ],
            ),
*/

            // Show selected tracker history info and controls

            if (_selectedTracker != null && _showBottomPanel == false) TrackerInfoPanel(_selectedTracker!),

            //TrackerList(widget.trackable),
          ],
        ),
      ),
      floatingActionButton: _showBottomPanel == true
          ? null
          : FloatingActionButton(
              onPressed: () {
                _addTrackerPopup(context);
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      bottomSheet: _showBottomPanel == false ? null : _bottomButtonPanel,
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
                  setState(() {
                    _showBottomPanel = !_showBottomPanel;
                  });
                },
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Favorite',
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
