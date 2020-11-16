import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotifyflutterapp/services/api_auth_service.dart';
import 'package:spotifyflutterapp/ui/auth/auth_page.dart';
import 'package:spotifyflutterapp/ui/home/home_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      FutureProvider<ApiAuthService>(
        create: (_) async => ApiAuthService.createApiAuthService(),
        lazy: false,
      )
    ],
    child: MyApp(),),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: FutureBuilder(
        future: decideInitialPage(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.data == null) {
                return AuthPage();
              } else {
                return HomePage();
              }
          }
          return Container();
        },
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/auth': (BuildContext context) => AuthPage(),
        // TODO
        // The code below is not working as expected.
        // Require additional implementation of handling intent.
        '/callback': (BuildContext context) => HomePage(),
      },
    );
  }
}

Future<String> decideInitialPage(BuildContext context) async {

  // check login status in shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('loggedIn');
}
