import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:symptom_tracker/managers/event_manager.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';

class InfoHeader extends StatefulWidget {
  const InfoHeader({Key? key}) : super(key: key);

  @override
  State<InfoHeader> createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  Trackable get _selectedTarget => EventManager.selectedTarget;
  late StreamSubscription trackerSubscription;

  @override
  void initState() {
    super.initState();

    trackerSubscription = EventManager.stream.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Colors.orangeAccent,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [

                  const FaIcon(
                  FontAwesomeIcons.dog,
                  size: 35,
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).copyWith().size.width,
                    child: Text(
                      _selectedTarget.title ?? "DOG",
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),

              ]
              ),
            ),
          ),
        );
  }
}
