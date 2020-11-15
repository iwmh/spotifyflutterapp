import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
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
            await _auth(context);
          },
        ),
      ),
    );
  }
}

_auth(BuildContext context) async {

  // get secrets from assets folder
  var secrets = await getSecretsFromAssets();

  /**
   * code and token exchange with AppAuth
   */
  FlutterAppAuth appAuth = FlutterAppAuth();
  final AuthorizationResponse result = await appAuth.authorize(
    AuthorizationRequest(
      secrets.clientId,
      secrets.redirectUrl,
      serviceConfiguration: AuthorizationServiceConfiguration(
        'https://accounts.spotify.com/authorize',
        'https://accounts.spotify.com/api/token'),
      scopes: ['user-modify-playback-state', 'user-library-modify', 'playlist-read-private', 'playlist-modify-public', 'playlist-modify-private', 'user-read-playback-state', 'user-read-currently-playing']
    )
  );

  final TokenResponse tokenResponse = await appAuth.token(
    TokenRequest(
        secrets.clientId,
        secrets.redirectUrl,
        serviceConfiguration: AuthorizationServiceConfiguration(
            'https://accounts.spotify.com/authorize',
            'https://accounts.spotify.com/api/token'),
        authorizationCode: result.authorizationCode,
        codeVerifier: result.codeVerifier
      ),
    );

  final TokenResponse refreshTokenResponse = await appAuth.token(
    TokenRequest(
        secrets.clientId,
        secrets.redirectUrl,
        serviceConfiguration: AuthorizationServiceConfiguration(
            'https://accounts.spotify.com/authorize',
            'https://accounts.spotify.com/api/token'),
        refreshToken: tokenResponse.refreshToken
    ),
  );


  print("");

}

// store value to SharedPreferences
Future<void> storeString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, value);
}
