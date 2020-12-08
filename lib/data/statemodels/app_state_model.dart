import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/ui/auth/auth_page.dart';
import 'package:spotifyflutterapp/ui/home/home_page.dart';
import 'package:spotifyflutterapp/ui/tracks/tracks_page.dart';

class AppStateModel extends ChangeNotifier {
  // in-memory expiration date
  DateTime accessTokenExpirationDateTime;
  // im-memory access token
  String accessToken;

  // Once logged in.
  bool _loggedInBefore = false;
  get loggedInBefore {
    return _loggedInBefore;
  }

  set loggedInBefore(bool newState) {
    _loggedInBefore = newState;
    notifyListeners();
  }

  // used just at the startup....
  set loggedInBeforeWithoutNotifying(bool newState) {
    _loggedInBefore = newState;
  }

  // a playlists is selected
  String _selectedPlaylistId = '';
  get selectedPlaylistId {
    return _selectedPlaylistId;
  }

  set selectedPlaylistId(String newValue) {
    _selectedPlaylistId = newValue;
    notifyListeners();
  }

  int _currentIndex = 0;
  get currentIndex {
    return _currentIndex;
  }

  set currentIndex(int newIndex) {
    if (_currentIndex != newIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }

  static const List<Destination> allDestinations = <Destination>[
    Destination(0, 'Home', Icons.home, Colors.cyan),
    Destination(1, 'Settings', Icons.settings, Colors.cyan),
  ];
}

class Destination {
  const Destination(this.index, this.title, this.icon, this.color);
  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;
}

class AppRoutePath {
  final String playlistId;

  AppRoutePath.home() : playlistId = null;

  AppRoutePath.playlist(this.playlistId);

  bool get isHomePage => playlistId == null;

  bool get isPlaylistPage => playlistId != null;
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  final BuildContext _context;

  AppRouterDelegate(this._context) : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // if not logged in, show AuthPage.
      home: Scaffold(
        body: Navigator(
          pages: [
            // home page.
            if (Provider.of<ApiService>(context, listen: false).hasLoggedInBefore())
              MaterialPage(
                key: ValueKey('HomePage'),
                child: HomePage(),
              )
            else
              MaterialPage(
                key: ValueKey('AuthPage'),
                child: AuthPage(),
              ),

            // when a playlist is selected
            if (Provider.of<AppStateModel>(context, listen: false).selectedPlaylistId != '' &&
                Provider.of<AppStateModel>(context, listen: false).selectedPlaylistId != null)
              MaterialPage(
                key: ValueKey('TracksPage'),
                child: TracksPage(),
              )
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            var state = Provider.of<AppStateModel>(context, listen: false);
            state.selectedPlaylistId = null;
            return true;
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: Provider.of<AppStateModel>(context, listen: false).currentIndex,
          onTap: (int index) {
            var appState = Provider.of<AppStateModel>(context, listen: false);
            appState.currentIndex = index;
          },
          items: AppStateModel.allDestinations.map((Destination destination) {
            return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              backgroundColor: destination.color,
              label: destination.title,
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) {
    if (path.isPlaylistPage) {
      Consumer<AppStateModel>(
        builder: (_, state, child) {
          state.selectedPlaylistId = path.playlistId;
        },
      );
    } else {
      Consumer<AppStateModel>(
        builder: (_, state, child) {
          state.selectedPlaylistId = null;
        },
      );
    }
  }

  AppRoutePath get currentConfiguration {
    var state = Provider.of<AppStateModel>(_context, listen: false);
    if (state.selectedPlaylistId != '' && state.selectedPlaylistId != null) {
      return AppRoutePath.playlist(state.selectedPlaylistId);
    } else {
      return AppRoutePath.home();
    }
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    // handler '/'
    if (uri.pathSegments.length == 0) {
      return AppRoutePath.home();
    }

    // handler '/playlist/:id'
    if (uri.pathSegments.length == 2) {
      var remaining = uri.pathSegments[1];
      return AppRoutePath.playlist(remaining);
    }
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath path) {
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isPlaylistPage) {
      return RouteInformation(location: '/playlist/${path.playlistId}');
    }
    return null;
  }
}
