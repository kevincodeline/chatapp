import 'package:firebase_chat_tutorial/helper/helperfunctions.dart';
import 'package:firebase_chat_tutorial/view/chat_room_screen.dart';
import 'package:firebase_chat_tutorial/view/notification.dart';
import 'package:firebase_chat_tutorial/view/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'helper/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppNotificationHandler.getFcmToken();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: userIsLoggedIn != null
          ? userIsLoggedIn!
              ? ChatRoomScreen()
              : Authenticate()
          : Authenticate(),
    );
  }
}
