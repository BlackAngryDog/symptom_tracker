import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:symptom_tracker/model/tracker.dart';

class MiniCountTracker extends StatefulWidget {
  final Tracker _tracker;
  const MiniCountTracker(this._tracker, {Key? key}) : super(key: key);

  @override
  _MiniCountTrackerState createState() => _MiniCountTrackerState();
}

class _MiniCountTrackerState extends State<MiniCountTracker> {
  int currValue = 0;
  String subtitle = 'count today is 0';

  @override
  void initState() {
    super.initState();
    getCurrValue();
  }

  Future updateData() async {
    currValue++;
    await widget._tracker.updateLog(currValue);
    print('val');
    getCurrValue();
  }

  Future getCurrValue() async {
    currValue = int.tryParse(await widget._tracker.getLastValue(true)) ?? 0;

    setState(() {
      subtitle = 'today is $currValue';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.blueGrey,
          elevation: 5,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            side: BorderSide(width: 4, color: Colors.white38),
          ),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Stack(children: [
              Positioned(
                right: 10,
                bottom: 10,
                child: const FaIcon(
                  FontAwesomeIcons.weightScale,
                  size: 45,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text('1', style: TextStyle(fontSize: 32)),
              ),
            ]),
          ),
        ),
        Text(subtitle),
      ],
    );
  }
}
