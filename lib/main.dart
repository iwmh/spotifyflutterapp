import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/ui/auth/auth_page.dart';
import 'package:spotifyflutterapp/ui/home/home_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // init service
  final apiService = await ApiService.createApiAuthService();

  // for testing
  apiService.deleteAllDataInStorage();

  runApp(MultiProvider(
    providers: [
      // DI of the service relating to token exchange.
      Provider.value(
        value: apiService,
      ),
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
        future: Provider.of<ApiService>(context, listen: false).isLoggedIn(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.data) {
                // if user is logged in
                return HomePage();
              } else {
                return AuthPage();
              }
          }
          return Container();
        },
      ),
    );
  }
}
