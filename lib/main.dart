import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:symptom_tracker/model/data_log.dart';
import 'package:symptom_tracker/model/databaseTool.dart';
import 'package:symptom_tracker/model/trackable.dart';
import 'package:symptom_tracker/model/user.dart';
import 'package:symptom_tracker/pages/trackable_selection_page.dart';

import 'package:symptom_tracker/pages/trackable_setup_page.dart';
import 'package:symptom_tracker/pages/tracker_home.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as auth ;
import 'package:symptom_tracker/widgets/tracker_week.dart';

import 'firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(name: 'att', options: DefaultFirebaseConfig.platformOptions);
  } else {
    Firebase.app();
  }

  // FacebookSdk.sdkInitialize();
  FirebaseDatabase.instance.databaseURL = DefaultFirebaseConfig.platformOptions.databaseURL;
  FirebaseDatabase.instance.goOnline();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
   AuthGate({Key? key}) : super(key: key);

  var providers = [auth.EmailAuthProvider()];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return auth.SignInScreen(
            providers:providers,
            actions: [
              auth.AuthStateChangeAction<auth.SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
            ],
          );
        }

        // Load UserData
        return FutureBuilder<UserVo>(
          future: DatabaseTools.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Check if CurrTrackable set
              if (snapshot.data!.selectedID == null) {
                // Open On-boarding
                // TODO - CHECK IF ANY CURR DATA - open setup or selection list
                return const TrackableSelectionPage();
              } else {
                // Open tracker summery page
                return FutureBuilder<Trackable?>(
                    future: Trackable.load(snapshot.data!.selectedID ?? 'default'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return TrackerWeek(snapshot.data ?? Trackable());
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }
}
