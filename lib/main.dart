import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifyflutterapp/screens/auth.dart';
import 'package:spotifyflutterapp/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2 pages',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: _fBuilder(),
    );
  }
}

_fBuilder() {
  return FutureBuilder(
    future: _loggedIn(),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.active:
        case ConnectionState.waiting:
          return CircularProgressIndicator();
        case ConnectionState.done:
          if (snapshot.data == null || !snapshot.data) {
            return AuthPage();
          } else {
            return HomePage();
          }
      }
      return Container();
    },
  );
}

Future<bool> _loggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('loggedIn');
}
