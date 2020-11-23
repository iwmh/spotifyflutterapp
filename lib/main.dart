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

  // init service
  final apiService = await ApiService.createApiAuthService();
  // set the new state
  apiService.appState = new AppStateModel();
  // initialize with the state
  await apiService.init();

  // TODO: remove when not testing
  // for testing
  await apiService.deleteAllDataInStorage();

  runApp(
    MultiProvider(
      providers: [
        // Just a Provider.
        Provider(create: (_) => AppStateModel()),
        // ChangeNotifierProxyProvider because ApiService depends on AppStateModel.
        ChangeNotifierProxyProvider<AppStateModel, ApiService>(
          create: (_) => apiService,
          update: (_, appState, apiService) {
            // prevent clearing the state.
            if (appState.accessToken != null) {
              apiService.appState = appState;
            }
            return apiService;
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Provider.of<ApiService>(context).hasLoggedInBefore()
          ? cupeWid()
          : AuthPage(),
    );

    // return MaterialApp(
    //   theme: ThemeData(primarySwatch: Colors.lightGreen),
    //   home: Navigator(
    //     pages: [
    //       // Home page
    //       if (Provider.of<ApiService>(context).hasLoggedInBefore())
    //         MaterialPage(key: ValueKey('HomePage'), child: HomePage())
    //       else
    //         MaterialPage(key: ValueKey('AuthPage'), child: AuthPage())
    //     ],
    //     onPopPage: (route, result) {
    //       return route.didPop(result);
    //     },
    //   ),
    // );
  }
}

Widget cupeWid() {
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
