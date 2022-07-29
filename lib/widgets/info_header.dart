import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:symptom_tracker/model/event_manager.dart';
import 'package:symptom_tracker/model/trackable.dart';

class InfoHeader extends StatefulWidget {
  const InfoHeader({Key? key}) : super(key: key);

  @override
  State<InfoHeader> createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  late Trackable _selectedTarget;
  late StreamSubscription trackerSubscription;

  @override
  void initState() {
    super.initState();
    _selectedTarget = EventManager.selectedTarget;
    trackerSubscription = EventManager.stream.listen((event) {
      setState(() {
        _selectedTarget = EventManager.selectedTarget;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Colors.orangeAccent,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      color: Colors.transparent,
                      width: MediaQuery.of(context).copyWith().size.width,
                      child: Text(
                        _selectedTarget.title ?? "DOG",
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).copyWith().size.width,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                //MiniCountTracker(Tracker('default')),
                //MiniCountTracker(Tracker('default')),
                //MiniCountTracker(Tracker('default')),
              ],
            ),
          ),
          Positioned(
            //width: MediaQuery.of(context).copyWith().size.width,
            top: 10,
            left: 10,
            child: CircleAvatar(
              minRadius: 30,
              backgroundColor: Colors.grey.shade800,
              child: const FaIcon(
                FontAwesomeIcons.dog,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
