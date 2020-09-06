import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:windson/screens/auth_screen.dart';
import 'package:windson/screens/home_page.dart';
import 'package:windson/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wind Messaging',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.black,
          accentColor: Colors.white70,
          primaryColorBrightness: Brightness.dark,
          textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: Colors.teal,
          ),
          canvasColor: Colors.black,
        ),
        // fontFamily: 'orbitron'),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            }
            return AuthScreen();
          },
        ));
  }
}
