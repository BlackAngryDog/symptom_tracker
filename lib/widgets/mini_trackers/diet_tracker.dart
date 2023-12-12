import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/diet_options_page.dart';

class MiniDietTracker extends StatefulWidget {
  final Tracker _tracker;
  const MiniDietTracker(this._tracker, {Key? key}) : super(key: key);

  @override
  _MiniDietTrackerState createState() => _MiniDietTrackerState();
}

class _MiniDietTrackerState extends State<MiniDietTracker> {
  int currValue = 0;
  String subtitle = 'Diet';

  @override
  void initState() {
    super.initState();
  }

  Future showOptions(BuildContext ctx) async {
    // SHOW FOOD LIST
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => const DietOptionsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          const Card(
            color: Colors.blueGrey,
            elevation: 5,
            shape: RoundedRectangleBorder(
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
                  child: Icon(
                    Icons.add,
                    size: 40,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text('1', style: TextStyle(fontSize: 32)),
                ),
              ]),
            ),
          ),
          Text(widget._tracker.option.title ?? ''),
        ],
      ),
      onTap: () {
        showOptions(context);
      },
    );
  }
}
