import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/trackable.dart';

class ChartPage extends StatefulWidget {
  final Trackable trackable;
  const ChartPage(this.trackable, {Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<DataLog> roseData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('history'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream:
                DataLog.getCollection(widget.trackable.id ?? "Default").orderBy('time', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 350,
                  height: 300,
                  child: const Text("TODO"),
                );
              }
            }),
      ),
    );
  }
}
