import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/tracker.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';
import 'package:symptom_tracker/widgets/trackers/count_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/quality_tracker.dart';
import 'package:symptom_tracker/widgets/trackers/value_tracker.dart';

class TrackableItem extends StatelessWidget {
  final Trackable item;
  const TrackableItem(this.item, {Key? key}) : super(key: key);

  void select(BuildContext ctx) {
    DatabaseTools.getUser().then((value) {
      value.selectedID = item.id;
      value.save();
      Navigator.pop(ctx, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(item.title ?? ""),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
            ),
          ),
        ),
      ),
      onTap: () {
        select(context);
      },
    );
  }
}
