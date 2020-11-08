import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/repositories/secure_storage_repository.dart';
import 'package:spotifyflutterapp/util/constants.dart';
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
          onTap: () async {
            await _launchUrl(context);
          },
        ),
      ),
    );
  }
}

_launchUrl(BuildContext context) async {

  // get secrets from assets folder
  var secrets = await getSecretsFromAssets();

  // parameters required to to authorization code flow with PKCE
  var CODE_VERIFIER = '';
  var CODE_CHALLENGE = '';
  var STATE = '';

  // string from which random string is created.
  const random_string_source = 'abcdefghijklmnopqrstuvwxfzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_.-~';
  const random_string_source_length = random_string_source.length;

  // generate CODE_VERIFIER
  final rand = new Random();
  for(var i = 0; i < 128; i++){
    final n = rand.nextInt(random_string_source_length);
    CODE_VERIFIER += random_string_source[n];
  }

  // create CODE_CHALLENGER from CODE_VERIFIER
  CODE_CHALLENGE = createCodeChallengeFromCodeVerifier(CODE_VERIFIER);
  
  // generate STATE, 
  // and store its value to SharedPreferences to use it for comparison, later.
  for(var i = 0; i < 128; i++){
    final n = rand.nextInt(random_string_source_length);
    STATE += random_string_source[n];
  }
  final secureStorage = Provider.of<SecureStorage>(context, listen: false);
  await secureStorage.storeDateToStorage(Constants.PKCE_STATE, STATE);

  var queryParameters = {
    'client_id': secrets.clientId,
    'response_type': 'code',
    'redirect_uri': secrets.redirectUrl,
    'code_challenge_method': 'S256',
    'code_challenge': CODE_CHALLENGE,
    'state': STATE,
    'scope': 'user-modify-playback-state user-library-modify playlist-read-private playlist-modify-public playlist-modify-private user-read-playback-state user-read-currently-playing',
  };

  var uri = Uri.https('accounts.spotify.com', '/authorize', queryParameters).toString();

  if(await canLaunch(uri)){
    await launch(uri);
  } else {
    throw 'Could not launch $uri';
  }

}

// store value to SharedPreferences
Future<void> storeString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, value);
}
