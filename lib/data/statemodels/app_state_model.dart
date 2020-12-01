import 'package:flutter/cupertino.dart';

class AppStateModel extends ChangeNotifier {
  // in-memory expiration date
  DateTime accessTokenExpirationDateTime;
  // im-memory access token
  String accessToken;
  // Once logged in
  bool _loggedInBefore = false;

  get loggedInBefore {
    return _loggedInBefore;
  }

  set loggedInBefore(bool newState) {
    _loggedInBefore = newState;
    notifyListeners();
  }

  set loggedInBeforeWithoutNotifying(bool newState) {
    _loggedInBefore = newState;
  }
}
