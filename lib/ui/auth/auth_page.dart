import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifyflutterapp/util/util.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('auth page!'),
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            color: Colors.grey,
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            padding: EdgeInsets.all(20),
          ),
          onTap: () {
            _logIn();
          },
        ),
      ),
    );
  }
}

Future<void> _logIn() async {
  // get secrets
  var secrets = await getSecretsFromAssets();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool('loggedIn', true);
}
