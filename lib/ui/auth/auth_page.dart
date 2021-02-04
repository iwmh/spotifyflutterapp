import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Image(
              image: AssetImage('assets/logo_no_background.png'),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: 'In this app, those tracks in your playlists that\n'),
                    TextSpan(text: '・are adjacent with each other, and that\n'),
                    TextSpan(text: '・belong to the same album,\n'),
                    TextSpan(text: 'are seen as "albums".\n\n'),
                    TextSpan(text: 'And you can sort those "albums" as you want in your playlists."\n'),
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                color: Colors.grey,
                child: const Text(
                  "Login with Spotify",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                padding: const EdgeInsets.all(20),
              ),
              onTap: () async {
                await _auth(context);
              },
            ),
          ],
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
