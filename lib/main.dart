import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/statemodels/app_state_model.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/ui/auth/auth_page.dart';
import 'package:spotifyflutterapp/ui/home/home_page.dart';
import 'package:spotifyflutterapp/ui/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // create service
  final apiService = await ApiService.createApiAuthService();
  // initialize with the state
  // (read token info from storage and set them to state.)
  await apiService.init();

  // TODO: remove when not testing
  // for testing
  // await apiService.deleteAllDataInStorage();

  runApp(
    MultiProvider(
      providers: [
        // Just a Provider.
        ChangeNotifierProvider(
          create: (_) => AppStateModel(),
        ),
        // ChangeNotifierProxyProvider because ApiService depends on AppStateModel.
        ProxyProvider<AppStateModel, ApiService>(
          create: (context) {
            final appState = Provider.of<AppStateModel>(context, listen: false);

            // set state values when you init() to the descendent state.
            appState.accessToken = apiService.accessToken;
            appState.accessTokenExpirationDateTime = apiService.accessTokenExpirationDateTime;
            appState.loggedInBefore = apiService.loggedInBefore;

            apiService.appState = appState;
            return apiService;
          },
          update: (_, appState, apiService) {
            // prevent clearing the state.
            if (appState.accessToken != null) {
              apiService.appState = appState;
            }
            return apiService;
          },
        ),
      ],
      child: Consumer<AppStateModel>(
        builder: (context, value, child) {
          return MyApp();
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // if not logged in, show AuthPage.
      home: Provider.of<ApiService>(context).hasLoggedInBefore() ? cupertinoTabWidet() : AuthPage(),
    );
  }
}

Widget cupertinoTabWidet() {
  return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings')
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(child: HomePage());
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(child: SettingsPage());
            });
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(child: HomePage());
            });
        }
      });
}
