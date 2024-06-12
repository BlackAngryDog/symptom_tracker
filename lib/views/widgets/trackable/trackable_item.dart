import 'package:flutter/material.dart';
import 'package:symptom_tracker/services/database_service.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';
import 'package:symptom_tracker/managers/event_manager.dart';


class TrackableItem extends StatelessWidget {
  final Trackable item;
  const TrackableItem(this.item, {Key? key}) : super(key: key);

  void select(BuildContext ctx) {
    DatabaseService.getUser().then((user) {
      user?.selectedID = item.id;
      user?.save().then((user) => {
        Trackable.load(item.id??"").then((value) => {
          EventManager.selectedTarget = value,
          Navigator.pop(ctx, item),
          EventManager.dispatchUpdate(UpdateEvent(EventType.trackableChanged)),
        })
      }).catchError(
        (error) => print("Error saving user:")
      );
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
