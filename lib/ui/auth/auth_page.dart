import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifyflutterapp/util/util.dart';
import 'package:url_launcher/url_launcher.dart';

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
            _launchUrl();
          },
        ),
      ),
    );
  }
}

_launchUrl() async {

  var secrets = await getSecretsFromAssets();

  var queryParameters = {
    'client_id': secrets.clientId,
    'response_type': 'code',
    'scope': 'user-modify-playback-state user-library-modify playlist-read-private playlist-modify-public playlist-modify-private user-read-playback-state user-read-currently-playing',
    'redirect_uri': secrets.redirectUrl
  };

  var uri = Uri.https('accounts.spotify.com', '/authorize', queryParameters).toString();

  if(await canLaunch(uri)){
    await launch(uri);
  } else {
    throw 'Could not launch $uri';
  }

}

Future<void> _logIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool('loggedIn', true);
}
