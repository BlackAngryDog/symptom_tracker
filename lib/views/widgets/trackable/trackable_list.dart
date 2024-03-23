import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';
import 'package:symptom_tracker/views/pages/trackable_setup_page.dart';
import 'package:symptom_tracker/views/widgets/trackable/trackable_item.dart';

class TrackableList extends StatelessWidget {
  final Function(BuildContext)? addTrackerPage;
  TrackableList({Key? key, this.addTrackerPage}) : super(key: key);

  final db = FirebaseFirestore.instance;

  bool _hasTracker(List? data) {
    return data!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).copyWith().size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: Trackable.collection().snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _hasTracker(snapshot.data?.docs)
                ? ListView(
                    children: snapshot.data?.docs.map((doc) {

                      return TrackableItem(Trackable.fromJson(doc.id, doc.data() as Map<String, dynamic>));
                    }).toList() as List<TrackableItem>,
                  )
                : const TrackableSetupPage();
          }
        },
      ),
    );
  }
}
