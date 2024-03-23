import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:symptom_tracker/services/database_service.dart';
import 'package:symptom_tracker/model/database_objects/trackable.dart';
import 'package:symptom_tracker/model/database_objects/user.dart';
import 'package:symptom_tracker/views/pages/trackable_selection_page.dart';
import 'package:symptom_tracker/views/pages/home/tracker_home.dart';
import 'package:symptom_tracker/theme/theme.dart';

import 'firebase_config.dart';
import 'managers/event_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        name: 'att', options: DefaultFirebaseConfig.platformOptions);
  } else {
    Firebase.app();
  }

  // FacebookSdk.sdkInitialize();
  FirebaseDatabase.instance.databaseURL =
      DefaultFirebaseConfig.platformOptions.databaseURL;
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
      theme: ThemeProvider.getTheme(),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  AuthGate({Key? key}) : super(key: key);

  final providers = [auth.EmailAuthProvider()];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return auth.SignInScreen(
            providers: providers,
            actions: [
              auth.AuthStateChangeAction<auth.SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
            ],
          );
        }

        // Load UserData
        return FutureBuilder<UserVo?>(
          future: DatabaseService.getUser(),
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
                    future:
                        Trackable.load(snapshot.data!.selectedID ?? 'default'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        EventManager(snapshot.data ?? Trackable());
                        return TrackerPage(snapshot.data ?? Trackable());
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
