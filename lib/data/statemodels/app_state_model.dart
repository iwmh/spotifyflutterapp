import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/ui/auth/auth_page.dart';
import 'package:spotifyflutterapp/ui/home/home_page.dart';
import 'package:spotifyflutterapp/ui/playlist/playlist_page.dart';
import 'package:spotifyflutterapp/ui/settings/settings.dart';

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

  static List<Destination> allDestinations = <Destination>[
    HomeDestination(0, 'Home', Icons.home, Colors.cyan),
    SettingsDestination(1, 'Settings', Icons.settings, Colors.cyan),
  ];
}

abstract class Destination {
  const Destination(this.index, this.title, this.icon, this.color);
  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;

  Page getPage() {}
}

class HomeDestination extends Destination {
  HomeDestination(int index, String title, IconData icon, MaterialColor color) : super(index, title, icon, color);

  Page getPage() {
    return HomePage();
  }
}

class SettingsDestination extends Destination {
  SettingsDestination(int index, String title, IconData icon, MaterialColor color) : super(index, title, icon, color);

  Page getPage() {
    return SettingsPage();
  }
}

class AppRoutePath {
  final bool hasLoggedInBefore;
  final String playlistId;

  AppRoutePath.auth()
      : hasLoggedInBefore = false,
        playlistId = null;

  AppRoutePath.home()
      : hasLoggedInBefore = true,
        playlistId = null;

  AppRoutePath.playlist(this.playlistId) : hasLoggedInBefore = true;

  AppRoutePath.settings()
      : hasLoggedInBefore = true,
        playlistId = null;

  bool get isAuthPage => !hasLoggedInBefore && playlistId == null;

  bool get isHomePage => playlistId == null;

  bool get isSettingsPage => playlistId == null;

  bool get isPlaylistPage => playlistId != null;
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    // handler '/'
    if (uri.pathSegments.length == 0) {
      return AppRoutePath.home();
    }

    // handler '/auth'
    if (uri.pathSegments.length == 1) {
      var remaining = uri.pathSegments[0];
      if (remaining == 'auth') {
        return AppRoutePath.auth();
      }
    }

    // handler '/playlist/:id'
    if (uri.pathSegments.length == 2) {
      var remaining = uri.pathSegments[1];
      return AppRoutePath.playlist(remaining);
    }
    throw '404 ?';
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (configuration.isAuthPage) {
      return RouteInformation(location: '/auth');
    }
    if (configuration.isPlaylistPage) {
      return RouteInformation(location: '/playlist/${configuration.playlistId}');
    }
    return null;
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  List<Page> _pages = [];
  List<Page> get pages => _pages;
  set pages(List<Page> pages) {
    _pages = pages;
    notifyListeners();
  }

  String _playlistId;
  String get playlistId => _playlistId;
  set playlistId(String playlistId) {
    _playlistId = playlistId;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) {
    if (configuration.hasLoggedInBefore) {
      _pages = <Page>[HomePage()];
    } else {
      _pages = <Page>[AuthPage()];
    }

    if (configuration.isPlaylistPage) {
      _pages.add(PlaylistPage());
    }
    return SynchronousFuture<void>(null);
  }

  AppRoutePath get currentConfiguration {
    if (_pages.last is AuthPage) return AppRoutePath.auth();
    if (_pages.last is HomePage) return AppRoutePath.home();
    if (_pages.last is PlaylistPage) return AppRoutePath.playlist(playlistId);
    if (_pages.last is SettingsPage) return AppRoutePath.settings();
    throw 'unknown route?';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // if not logged in, show AuthPage.
      home: Scaffold(
        body: Navigator(
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return HomePage().createRoute(context);
            }
          },
          pages: _pages,
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
            var page = AppStateModel.allDestinations[index].getPage();
            pages = List<Page>.from(pages..add(page));
            // var appState = Provider.of<AppStateModel>(context, listen: false);
            // appState.currentIndex = index;
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
}
