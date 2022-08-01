import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/diet_option.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/widgets/add_diet_option_popup.dart';
import 'package:symptom_tracker/widgets/add_tracker_popup.dart';
import 'package:symptom_tracker/widgets/diet_option_item.dart';
import 'package:collection/collection.dart';
import 'package:symptom_tracker/widgets/tracker_item.dart';

class TrackerOptionsPage extends StatefulWidget {
  final Trackable _trackable;
  const TrackerOptionsPage(this._trackable, {Key? key}) : super(key: key);

  @override
  State<TrackerOptionsPage> createState() => _TrackerOptionsPageState();
}

class _TrackerOptionsPageState extends State<TrackerOptionsPage> {
  List<DietOptionItem> options = [];

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

      TrackOption option = TrackOption(title: value.title, trackType: value.type);
      option.save();

      //Tracker tracker = value;
      //tracker.trackableID = widget._trackable.id ?? 'default';
      //tracker.save();
    });
  }

/*
  Future<List<DietOptionItem>> _getData() async {
    DataLog? log = await widget._trackable.getLastEntry(false);

    // SELECT OPTIONS FROM DATA
    final test = log?.value;

    for (var entry in test.entries) {
      DietOptionItem? option = options.where((element) => element.item.title == entry.key).firstOrNull;
      option?.selected = entry.value;
    }

    return options;
  }

 */

  void showInitialSettingsPopup(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              "Create ID",
              style: TextStyle(fontSize: 24.0),
            ),
            content: SizedBox(
              height: 400,
              child: Card(),
            ),
          );
        });
  }

  Future<List<DietOptionItem>> _getData() async {
    List<TrackOption> entries = widget._trackable.trackers;

    if (entries.isEmpty) return options;

    // SELECT OPTIONS FROM DATA

    for (TrackOption entry in entries) {
      DietOptionItem? option = options.where((element) => element.item.title == entry.title).firstOrNull;
      option?.selected = true;
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title.
        title: Text('Select Symptoms to track'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                _addTrackerPopup(context);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).copyWith().size.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: TrackOption.getCollection().orderBy('title').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  options = snapshot.data?.docs.map((doc) {
                    return DietOptionItem<TrackOption>(
                        false, TrackOption.fromJson(doc.id, doc.data() as Map<String, dynamic>));
                  }).toList() as List<DietOptionItem>;

                  return FutureBuilder<List<DietOptionItem>>(
                      future: _getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: options,
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      });
                }
              }),
        ),
      ),
      floatingActionButton: ButtonBar(
        children: <Widget>[
          ElevatedButton(
            child: Text('Next'),
            onPressed: () {
              // GOTO INITIAL SETUP FOR TRACKERS -
              //showInitialSettingsPopup(context, 1);
              initialiseTrackable(context);
            },
          ),
          ElevatedButton(
            child: Text('Back'),
            onPressed: () {
              // To do - pop nav
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future initialiseTrackable(BuildContext context) async {
    widget._trackable.trackers = options
        .where((element) => element.selected == true)
        .map((value) => TrackOption(title: value.item.title, trackType: value.item.trackType))
        .toList();
    await widget._trackable.save();
    // Update tracking data for trackable (how to delete?)
    // TODO - MAKE THIS A FUNCTION
    //for (DietOptionItem item in options) {
    //  if (item.selected) {
    //    TrackOption option = item.item;
    //    Tracker tracker = Tracker(widget._trackable.id ?? 'default', title: option.title, type: option.trackType);
    // TODO - NEED TO CHECK IF ADDING/REMOVING
    //    await tracker.save();
    //  }
    // }

    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TrackerPage(
                widget._trackable,
              )),
    );
  }
}
