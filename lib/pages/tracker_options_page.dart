import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/track_option.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/popups/add_tracker_popup.dart';
import 'package:symptom_tracker/widgets/diet_option_item.dart';

import '../widgets/track_option_item.dart';


class TrackerOptionsPage extends StatefulWidget {
  final Trackable _trackable;
  const TrackerOptionsPage(this._trackable, {Key? key}) : super(key: key);

  @override
  State<TrackerOptionsPage> createState() => _TrackerOptionsPageState();
}

class _TrackerOptionsPageState extends State<TrackerOptionsPage> {
  List<TrackOptionItem> _options = [];
  List<TrackOption> _activeOptions = [];

  @override
  void initState() {
    super.initState();
    _updateOptions();
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

  void _addTracker(TrackOption option) {
    _activeOptions.add(option);
    _updateOptions();
  }

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

  Future _updateOptions() async {
    _options = await _getData();
    setState(() {});
  }

  Future<List<TrackOptionItem>> _getData() async {
    var dataList = await TrackOption.getOptions();
    _options = dataList.map((option) {
      return TrackOptionItem<TrackOption>(
          false,
          option);
    }).toList();

    _activeOptions = _activeOptions.isEmpty
        ? await widget._trackable.getTrackOptions()
        : _activeOptions;

    if (_activeOptions.isEmpty) return _options;

    int index = 0;
    for (TrackOption entry in _activeOptions) {
      TrackOptionItem? option = _options
          .where((element) => element.item.title == entry.title)
          .firstOrNull;
      option?.selected = true;
      option?.order = index++;
    }

    // sort options on selected and order
    _options.sort((a, b) {
      if (a.selected == b.selected) {
        return a.order.compareTo(b.order);
      } else {
        return a.selected ? -1 : 1;
      }
    });

    return _options;
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
          child: (_options.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : ListView(children: _options)
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        //notchMargin: 3,
       // height: 60,
        //elevation: 10,
        //padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            IconButton.filled(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
            ),
            const Spacer(),
            IconButton.filled(
                onPressed: () {
                    _addTrackerPopup(context);
                },
                icon:  const Icon(Icons.add),
            ),
            const Spacer(),
            IconButton.filled(
              onPressed: () {
                initialiseTrackable(context);
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
      ),
      
    );

  }

  void initialiseTrackable(BuildContext context) {
    widget._trackable.loadTrackOptions(_options
        .where((element) => element.selected == true)
        .map((value) => value.item.id.toString())
        .toList());

    widget._trackable.save();
    Navigator.of(context).pop();

  }
}
