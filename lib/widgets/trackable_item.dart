import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';

class TrackableItem extends StatelessWidget {
  final Trackable item;
  const TrackableItem(this.item, {Key? key}) : super(key: key);

  void select(BuildContext ctx) {
    DatabaseTools.getUser().then((value) {
      value.selectedID = item.id;
      value.save();
      // TODO - MAY NEED TO OPEN TRACKER HOME PAGE
      // Navigator
     // Navigator.pop(ctx, item);
      //EventManager.selectedTarget = item;
      //EventManager.dispatchUpdate(UpdateEvent(EventType.trackableChaned));
      ///*
      Trackable.load(item.id??"").then((value) => {
        EventManager.selectedTarget = value,
        Navigator.pop(ctx, item),
        EventManager.dispatchUpdate(UpdateEvent(EventType.trackableChaned)),
      });

     //  */


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
