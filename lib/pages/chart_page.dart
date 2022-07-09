import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:symptom_tracker/model/trackable.dart';

class ChartPage extends StatefulWidget {
  final Trackable trackable;
  const ChartPage(this.trackable, {Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final List<Map<String, Object>> roseData = [
    {'value': 20, 'name': 'rose 1'},
    {'value': 10, 'name': 'rose 2'},
    {'value': 24, 'name': 'rose 3'},
    {'value': 12, 'name': 'rose 4'},
    {'value': 20, 'name': 'rose 5'},
    {'value': 15, 'name': 'rose 6'},
    {'value': 22, 'name': 'rose 7'},
    {'value': 29, 'name': 'rose 8'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('history'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          width: 350,
          height: 300,
          child: Chart(
            data: roseData,
            variables: {
              'name': Variable(
                accessor: (Map map) => map['name'] as String,
              ),
              'value': Variable(
                accessor: (Map map) => map['value'] as num,
                scale: LinearScale(min: 0, marginMax: 0.1),
              ),
            },
            elements: [
              IntervalElement(
                label: LabelAttr(encoder: (tuple) => Label(tuple['name'].toString())),
                shape: ShapeAttr(
                    value: RectShape(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                )),
                color: ColorAttr(variable: 'name', values: Defaults.colors10),
                elevation: ElevationAttr(value: 5),
              )
            ],
            //coord: PolarCoord(startRadius: 0.15),
            axes: [
              Defaults.horizontalAxis,
              Defaults.verticalAxis,
            ],
          ),
        ),
      ),
    );
  }
}
