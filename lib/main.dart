import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/statemodels/app_state_model.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/ui/auth/auth_page.dart';
import 'package:spotifyflutterapp/ui/home/home_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // init service
  final apiService = await ApiService.createApiAuthService();
  apiService.init();

  // TODO: remove when not testing
  // for testing
  apiService.deleteAllDataInStorage();

  runApp(MultiProvider(
    providers: [
      // Just a Provider.
      Provider(create: (_) => AppStateModel()),
      // ChangeNotifierProxyProvider because ApiService depends on AppStateModel.
      ChangeNotifierProxyProvider<AppStateModel, ApiService>(
          create: (_) => apiService,
          update: (_, appState, apiService) {
            apiService.appState = appState;
            return apiService;
          }
      ),
    ],
    child: MyApp(),),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: Navigator(
        pages: [
          // Home page
          if(Provider.of<ApiService>(context).hasLoggedInBefore())
            MaterialPage(key: ValueKey('HomePage'), child: HomePage())
          else
            MaterialPage(key: ValueKey('AuthPage'), child: AuthPage())
        ],
        onPopPage: (route, result){
          return true;
        },
      ),
    );
  }
}
