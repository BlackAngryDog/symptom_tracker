import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';

class WeekInfoGrid extends StatefulWidget {
  final List<String> _data;
  final DateTime date;

  const WeekInfoGrid(this._data, this.date, {Key? key}) : super(key: key);

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
    final count = widget._data.length - 1;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          mainAxisExtent: height),
      itemCount: 7,
      itemBuilder: (BuildContext ctx, index) {
        // Add your card/widget/grid element here

        return Container(
          color: Colors.transparent,
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).copyWith().size.height,
          width: MediaQuery.of(context).copyWith().size.width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Text(
                widget._data[widget.date
                        .subtract(Duration(days: count - index))
                        .weekday -
                    1],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
