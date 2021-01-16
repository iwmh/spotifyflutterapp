import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('auth page!'),
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            color: Colors.grey,
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            padding: const EdgeInsets.all(20),
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
  await authService.getAndStoreCurrentUserProdile();
}
