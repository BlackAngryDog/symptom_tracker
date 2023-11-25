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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 50, crossAxisSpacing: 0, mainAxisSpacing: 0),
      itemCount: widget._data.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext ctx, index) {
        // Add your card/widget/grid element here
        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          height: MediaQuery.of(context).copyWith().size.height,
          width: MediaQuery.of(context).copyWith().size.width,
          child: Row(
            children: [
              Text(widget._data[index]),
              VerticalDivider(
                color: Colors.red,
                thickness: 20,
              )
            ],
          ),
        );
      },
    );
  }
}
