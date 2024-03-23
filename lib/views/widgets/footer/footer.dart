import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/views/pages/diet_options_page.dart';
import 'package:symptom_tracker/views/pages/tracker_options_page.dart';
import 'package:symptom_tracker/views/widgets/bottom_tracker_panel.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  Future showDietOptions(BuildContext ctx) async {
    // SHOW FOOD LIST
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => const DietOptionsPage(),
      ),
    );
  }

  Future showTrackingOptions(BuildContext ctx) async {
    // SHOW FOOD LIST
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => TrackerOptionsPage(),
      ),
    );
  }

  void _showTrackerPanel(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: const BottomTrackerSelectionPanel(),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 3,
      height: 60,
      elevation: 10,
      padding: const EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Open navigation menu',
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showTrackerPanel(context);
            },
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () {
              showTrackingOptions(context);
            },
          ),
          IconButton(
            tooltip: 'Favorite',
            icon: const Icon(Icons.rice_bowl_rounded),
            onPressed: () {
              showDietOptions(context);
            },
          ),
        ],
      ),
    );
  }
}
