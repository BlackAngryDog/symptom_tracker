import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/popups/add_tracker_popup.dart';
import 'package:symptom_tracker/widgets/diet_option_item.dart';


class TrackerOptionsPage extends StatefulWidget {
  final Trackable _trackable;
  const TrackerOptionsPage(this._trackable, {Key? key}) : super(key: key);

  @override
  State<TrackerOptionsPage> createState() => _TrackerOptionsPageState();
}

class _TrackerOptionsPageState extends State<TrackerOptionsPage> {
  List<DietOptionItem> options = [];

  /*
  void _addTrackerPopup(BuildContext ctx) {
    var value = TrackOption();
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: AddTracker(_addTracker, value),
          );
        });
  }
  */

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

  void _addTracker(TrackOption option) {
    // DatabaseTools.testFirestore();

    setState(() {
      // TODO - CREATE A NEW TRACKER IN THE TRACKABLE (NEEDS POPUP FOR PARAMS)

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
          return const AlertDialog(
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
    var dataList = await TrackOption.getOptions();
    options = dataList.map((option) {
      return DietOptionItem<TrackOption>(
          false,
          option);
    }).toList();

    List<TrackOption> entries = await widget._trackable.getTrackOptions();

    if (entries.isEmpty) return options;

    int index = 0;

    for (TrackOption entry in entries) {
      DietOptionItem? option = options
          .where((element) => element.item.title == entry.title)
          .firstOrNull;
      option?.selected = true;
      option?.order = index++;
    }

    // TODO - add order to diet options and make sure it's saved with the option - can this be loaded from tracker screen just for consistency

    // sort options on selected and order
    options.sort((a, b) {
      if (a.selected == b.selected) {
        return a.order.compareTo(b.order);
      } else {
        return a.selected ? -1 : 1;
      }
    });



    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title.
        title: const Text('Select Symptoms to track'),
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
        child: SizedBox(
          height: MediaQuery.of(context).copyWith().size.height,
          child: FutureBuilder<List<DietOptionItem>>(
                      future: _getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: options,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
        ),
      ),


      bottomNavigationBar: BottomAppBar(
        //notchMargin: 3,
       // height: 60,
        //elevation: 10,
        //padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                    _addTrackerPopup(context);
                },
                icon:  const Icon(Icons.add),
            ),
            const Spacer(),
            ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                initialiseTrackable(context);
              },
            ),
          ],
        ),
      ),
      
    ); // This trailing comma makes auto-formatting nicer for build methods.
/*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTrackerPopup(context);
        },
        tooltip: 'Increment',
        mini: true,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniEndFloat,


    );

 */
  }

  void initialiseTrackable(BuildContext context) {
    widget._trackable.loadTrackOptions(options
        .where((element) => element.selected == true)
        .map((value) => value.item.id.toString())
        .toList());

    widget._trackable.save();
    Navigator.of(context).pop();

  }
}
