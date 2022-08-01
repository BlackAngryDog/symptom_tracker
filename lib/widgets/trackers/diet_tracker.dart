import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/diet_options_page.dart';
import 'package:symptom_tracker/pages/tracker_Summery.dart';

class DietTracker extends StatefulWidget {
  final Tracker _tracker;
  const DietTracker(this._tracker, {Key? key}) : super(key: key);

  @override
  State<DietTracker> createState() => _DietTrackerState();
}

class _DietTrackerState extends State<DietTracker> {
  List<String> currValue = []; // TODO - GET TODYS COUNT FOR TRACKER
  String subtitle = '';

  @override
  void initState() {
    super.initState();
    getCurrValue();
  }

  Future showOptions(BuildContext ctx) async {
    // SHOW FOOD LIST
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => DietOptionsPage(),
      ),
    );
  }

  Future getCurrValue() async {
    //currValue = int.tryParse(await widget._tracker.getLastValue(false)) ?? 0;

    setState(() {
      //subtitle = 'today is $currValue';
    });
  }

  void showHistory(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => TrackerSummeryPage(
          widget._tracker,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(widget._tracker.title ?? ""),
          subtitle: Text(subtitle),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    showOptions(context);
                  },
                  icon: const Icon(Icons.change_circle_outlined),
                ),
                /*PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      )
                    ];
                  },
                  onSelected: (String value) {
                    print('You Click on po up menu item');
                  },
                )*/
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        showHistory(context);
      },
    );
  }
}
