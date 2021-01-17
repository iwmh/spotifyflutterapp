import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/data/repositories/api_auth_repository.dart';
import 'package:spotifyflutterapp/data/repositories/api_client.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/repositories/secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/statemodels/app_state_model.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/ui/auth/auth_page.dart';
import 'package:spotifyflutterapp/util/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ~ preparing the dependencies ~

  // get secrets from assets folder
  var secrets = await getSecretsFromAssets();

  // appAuth
  final appAuth = FlutterAppAuth();

  // client for api
  final apiClient = ApiClient(appAuth);

  // inittialize repositories
  ApiAuthRepository apiAuthRepository = ApiAuthRepository(apiClient, secrets.clientId, secrets.redirectUrl);
  BaseSecureStorageRepository secureStorageRepository = SecureStorageRepository();

  // create service
  final apiService = ApiService(apiAuthRepository, secureStorageRepository);

  // initialize with the state
  // (read token info from storage and set them to state.)
  await apiService.init();

  // TODO: remove when not testing
  // for testing
  // await apiService.deleteAllDataInStorage();

  runApp(
    MultiProvider(
      providers: [
        // application level state
        ChangeNotifierProvider(
          create: (_) => AppStateModel(),
        ),
        // ChangeNotifierProxyProvider because ApiService depends on AppStateModel.
        ProxyProvider<AppStateModel, ApiService>(
          lazy: false,
          create: (context) {
            final appState = Provider.of<AppStateModel>(context, listen: false);

            // set state values when you init() to the descendent state.
            appState.accessToken = apiService.accessToken;
            appState.accessTokenExpirationDateTime = apiService.accessTokenExpirationDateTime;
            appState.displayName = apiService.displayName;
            // not to notify for it's while building.
            appState.loggedInBeforeWithoutNotifying = apiService.loggedInBefore;

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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouteInformationParser = AppRouteInformationParser();
  final _appRouterDelegate = AppRouterDelegate();
  final _routeInformationProvider = PlatformRouteInformationProvider(
    initialRouteInformation: const RouteInformation(location: '/'),
  );
  // var _routeInformationProvider = AppRouteInformationProvider();
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context, listen: false);
    if (appState.loggedInBefore) {
      return MaterialApp.router(
        routeInformationParser: _appRouteInformationParser,
        routerDelegate: _appRouterDelegate,
        routeInformationProvider: _routeInformationProvider,
      );
    } else {
      return MaterialApp(
        home: AuthPage(),
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.greenAccent[400],
        ),
      );
    }
  }
}
