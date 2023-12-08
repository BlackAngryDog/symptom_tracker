import 'package:flutter/material.dart';

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

    final count = widget._data.length - 1;

    return Container(
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(count, (index) {
          return Expanded(
            child: Text(
              widget._data[count - index],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}
