import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

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
  var authService = Provider.of<ApiService>(context, listen: false);

  await authService.exchangeAuthorizationCodeAndAccessToken();

  // testing
  await authService.refreshAccessToken();
}
