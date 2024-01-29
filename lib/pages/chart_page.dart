import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/widgets/diet_chart.dart';
import 'package:symptom_tracker/widgets/line_chart_new.dart';

class ChartPage extends StatefulWidget {
  // TODO - Add a away to show just one tracker from load
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
        title: const Text('history'),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).copyWith().size.height,
          child:  Column(
            children: [
              Expanded(child: Row(
                children: [
                  //TODO - create a weight details widget - make weight a default tracker
                  Expanded(child: Text("Weight: 15",textAlign: TextAlign.center,)),
                  Expanded(child: DietChart()),
                ],
              )),
              Expanded(child: LineDataChart()),
            ],
          ),


        ),
      ),

    );
  }
}
