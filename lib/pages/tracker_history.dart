import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/widgets/data_log_list.dart';

class TrackerHistoryPage extends StatelessWidget {
  final Trackable trackable;
  const TrackerHistoryPage(this.trackable, {Key? key}) : super(key: key);

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
        title: Text(trackable.title ?? ""),
      ),
      body: Center(
// Center is a layout widget. It takes a single child and positions it
// in the middle of the parent.
        child: DataLogList(trackable),
      ),
    );
  }
}
