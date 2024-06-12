import 'package:flutter/material.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/views/pages/tracker_Summery.dart';

class ValueTracker extends StatefulWidget {
  final Tracker _tracker;
  final DateTime _trackerDate;
  const ValueTracker(this._tracker, this._trackerDate, {Key? key})
      : super(key: key);

  @override
  State<ValueTracker> createState() => _ValueTrackerState();
}

class _ValueTrackerState extends State<ValueTracker> {
  final myController = TextEditingController();
  String value = "";

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
    getCurrValue();
  }

  void _printLatestValue() {
    myController.text = "test";
    print('Second text field: ${myController.text}');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  String currValue = ''; // TODO - GET TODYS COUNT FOR TRACKER
  String subtitle = 'value is today is 0';
  IconData icon = Icons.arrow_right;

  Future updateData(String value) async {
    await widget._tracker.updateLog(value, widget._trackerDate);
    EventManager.dispatchUpdate(
        UpdateEvent(EventType.trackerChanged, tracker: widget._tracker));
    getCurrValue();
  }

  Future getCurrValue() async {
    double curr = double.tryParse(
            await widget._tracker.getValue(day: widget._trackerDate)) ??
        0;
    double last = double.tryParse(await widget._tracker.getValue(
            day: widget._trackerDate.add(const Duration(days: -1)))) ??
        0;

    // GET TREND ICON
    icon = Icons.arrow_right;
    if (curr > last) {
      icon = Icons.arrow_drop_up;
    } else if (curr < last) {
      icon = Icons.arrow_drop_down;
    }
    currValue = curr.toString();
    print('last $last , curr $curr');
    setState(() {
      subtitle = currValue.toString();
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

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Expanded(child: Text(value.isEmpty ? '0' : value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 24),)),
      GestureDetector(
        onTap: () {
            // Handle backspace button tap
            setState(() {
              if (value.isNotEmpty) {
                value = value.substring(0, value.length - 1);
              }
            });
        },
        child: const Card(

            child: Center(
              child: Icon(Icons.backspace),
            ),
        ),
      ),

              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items per row
                childAspectRatio: (MediaQuery.of(context).size.width) / (MediaQuery.of(context).size.height/3),

              ),
              itemBuilder: (BuildContext context, int index) {
                if (index < 9) {
                  // Numbers 1-9
                  return GestureDetector(
                    onTap: () {
                      // Handle number button tap
                      setState(() {
                        value += '${index+1}';
                      });

                    },
                    child: Card(
                      child: Center(
                        child: Text(
                          '${index+1}',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                } else if (index == 9) {
                  // Backspace button
                  return GestureDetector(
                    onTap: () {
                      // Handle backspace button tap
                      setState(() {
                        if (!value.contains('.')) {
                          value += '.';
                        }
                      });
                    },
                    child: const Card(
                      child: Center(
                        child: Text( '.',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                } else if (index == 10) {
                  // Number 0
                  return GestureDetector(
                    onTap: () {
                      // Handle number 0 button tap
                      setState(() {
                        value += '0';
                      });
                    },
                    child: const Card(
                      child: Center(
                        child: Text(
                          '0',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Submit button
                  return GestureDetector(
                    onTap: () {
                      // Handle submit button tap
                      setState(() {
                        updateData(value);
                      });
                    },
                    child: const Card(
                      child: Center(
                        child: Icon(Icons.check),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
