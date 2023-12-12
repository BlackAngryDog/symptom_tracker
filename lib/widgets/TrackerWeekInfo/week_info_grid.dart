import 'package:flutter/material.dart';

class WeekInfoGrid extends StatefulWidget {
  final List<String> _data;
  final DateTime date;

  const WeekInfoGrid(this._data, this.date, {Key? key}) : super(key: key);

  @override
  State<WeekInfoGrid> createState() => _WeekInfoGridState();
}

class _WeekInfoGridState extends State<WeekInfoGrid> {
  final List<String> _sortedDates = [];

  @override
  void initState() {
    int i = widget._data.length;
    while (--i >= 0) {
      var dayIndex = widget.date.subtract(Duration(days: i)).weekday;

      _sortedDates.add(widget._data[dayIndex - 1]);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget._data.length - 1;

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(count, (index) {
                return Expanded(
                  child: Text(
                    _sortedDates[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 20,
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Text(
              _sortedDates[6],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
