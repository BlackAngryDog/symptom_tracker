import 'package:flutter/material.dart';
import 'package:symptom_tracker/pages/trackable_setup_page.dart';
import 'package:symptom_tracker/widgets/appbar_popup_menu_button.dart';
import 'package:symptom_tracker/widgets/trackable_list.dart';

class TrackableSelectionPage extends StatefulWidget {
  final String title = "Select item";

  const TrackableSelectionPage({Key? key}) : super(key: key);

  @override
  State<TrackableSelectionPage> createState() => _TrackableSelectionPageState();
}

class _TrackableSelectionPageState extends State<TrackableSelectionPage> {
  @override
  void initState() {
    super.initState();

    // TEMP - CHECK IF NO TRACKABLES
  }

  void addTrackable(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TrackableSetupPage()),
    );
  }

  void logOut() {}

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
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              addTrackable(context);
            },
            icon: const Icon(Icons.add),
          ),
          AppBarMenuButton({
            'Add': () {
              addTrackable(context);
            },
            'Logout': logOut
          })
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: TrackableList(
          addTrackerPage: addTrackable,
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
       */
    );
  }
}
