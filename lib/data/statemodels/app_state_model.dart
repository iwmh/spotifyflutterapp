import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  Page getPage({ValueChanged<String> callback}) {}
}

class HomeDestination extends Destination {
  HomeDestination(int index, String title, IconData icon, MaterialColor color) : super(index, title, icon, color);

  Page getPage({ValueChanged<String> callback}) {
    return HomePage(onTapped: callback);
  }
}

class SettingsDestination extends Destination {
  SettingsDestination(int index, String title, IconData icon, MaterialColor color) : super(index, title, icon, color);

  Page getPage({ValueChanged<String> callback}) {
    return SettingsPage();
  }
}

class AppRoutePath {
  final String playlistId;
  final bool isInHomeTab;
  final bool isInSettingsTab;

  AppRoutePath.home({this.playlistId})
      : isInHomeTab = true,
        isInSettingsTab = false;

  AppRoutePath.settings({this.playlistId})
      : isInHomeTab = false,
        isInSettingsTab = true;

  AppRoutePath.playlist(this.playlistId, {this.isInHomeTab, this.isInSettingsTab});

  bool get isHomeTab => isInHomeTab;

  bool get isSettingsTab => isInSettingsTab;

  bool get isPlaylistPage => playlistId != null;
}

// TODO: Keep this class in case it is needed, not knowing exactly how it should be used....
// class AppRouteInformationProvider extends RouteInformationProvider {
//   AppRouteInformationProvider() : _value = RouteInformation(location: '/');
//   RouteInformation _value;
//   @override
//   void addListener(void Function() listener) {
//     // TODO: implement addListener
//   }

//   @override
//   void removeListener(void Function() listener) {
//     // TODO: implement removeListener
//   }

//   @override
//   // TODO: implement value
//   RouteInformation get value => _value;

//   @override
//   void routerReportsNewRouteInformation(RouteInformation routeInformation) {
//     // TODO: implement routerReportsNewRouteInformation
//     super.routerReportsNewRouteInformation(routeInformation);
//   }
// }

// TODO: In mobile app, this parser doesn't seem to be used, other than at thet startup.
class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    // handler '/'
    if (uri.pathSegments.length == 0) {
      return AppRoutePath.home();
    }

    // handler '/settings/
    if (uri.pathSegments.length == 1) {
      var remaining = uri.pathSegments[0];
      if (remaining == '/settings') {
        return AppRoutePath.settings();
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
    if (configuration.isHomeTab != null && configuration.isHomeTab) {
      return RouteInformation(location: '/');
    }
    if (configuration.isInSettingsTab != null && configuration.isInSettingsTab) {
      return RouteInformation(location: '/settings');
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

  void _handlePlaylistTapped(String id) {
    // set playlsitId
    playlistId = id;

    var page = PlaylistPage(id);
    pages = List<Page>.from(pages..add(page));
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) {
    _pages = <Page>[HomePage(onTapped: _handlePlaylistTapped)];

    // if (configuration.isPlaylistPage) {
    //   _pages.add(PlaylistPage());
    // }
    return SynchronousFuture<void>(null);
  }

  AppRoutePath get currentConfiguration {
    if (_pages.isEmpty) return AppRoutePath.home();
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
              return HomePage(onTapped: _handlePlaylistTapped).createRoute(context);
            }
          },
          pages: _pages,
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            if (pages.last is PlaylistPage) {
              pages.removeLast();
            }

            return true;
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: Provider.of<AppStateModel>(context, listen: false).currentIndex,
          onTap: (int index) {
            var page;
            if (index == 0) {
              page = AppStateModel.allDestinations[index].getPage(callback: _handlePlaylistTapped);
            } else {
              page = AppStateModel.allDestinations[index].getPage();
            }
            pages = List<Page>.from(pages..add(page));
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
}
