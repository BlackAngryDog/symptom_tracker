import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/model/user.dart';
import 'package:symptom_tracker/pages/tracker_history.dart';
import 'package:symptom_tracker/widgets/data_log_list.dart';
import 'package:symptom_tracker/widgets/tracker_list.dart';

class TrackerPage extends StatefulWidget {
  final Trackable trackable;
  const TrackerPage(this.trackable, {Key? key}) : super(key: key);

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  int _counter = 0;
  bool _finishedLoading = false;

  @override
  void initState() {
    super.initState();
    // GET USER ID
    DatabaseTools.getUser().then((value) => print('user id is ${value.id}'));
  }

  void _addTracker() {
    // DatabaseTools.testFirestore();
    _counter++;
    setState(() {
      // TODO - CREATE A NEW TRACKER IN THE TRACKABLE (NEEDS POPUP FOR PARAMS)
      Tracker tracker = Tracker(widget.trackable.id ?? 'default',
          title: "test $_counter", type: "counter");
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.trackable.title ?? ""),
        actions: [
          IconButton(
              onPressed: () {
                showHistory(context);
              },
              icon: const Icon(Icons.remove_red_eye))
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: TrackerList(widget.trackable),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTracker,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
