import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
