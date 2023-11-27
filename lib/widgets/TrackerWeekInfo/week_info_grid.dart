import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';

class WeekInfoGrid extends StatefulWidget {
  final List<String> _data;

  const WeekInfoGrid(this._data, {Key? key}) : super(key: key);

  @override
  State<WeekInfoGrid> createState() => _WeekInfoGridState();
}

class _WeekInfoGridState extends State<WeekInfoGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.of(context).copyWith().size.height;
    return GridView.builder(
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, crossAxisSpacing: 0, mainAxisSpacing: 10, mainAxisExtent: height),
      itemCount: 7,

      itemBuilder: (BuildContext ctx, index) {
        // Add your card/widget/grid element here

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
          ),
          color: Colors.transparent,
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).copyWith().size.height,
          width: MediaQuery.of(context).copyWith().size.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              VerticalDivider(
                width: 0,
                color: Colors.red,
                thickness: 2,
              ),
              Text(
                widget._data[index],
                style: TextStyle(fontSize: 20, color: Colors.white,),
                textAlign: TextAlign.center,
              ),

            ],
          ),
        );
      },
    );
  }
}
