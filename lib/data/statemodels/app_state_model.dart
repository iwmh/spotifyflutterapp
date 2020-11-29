import 'package:flutter/cupertino.dart';

class AppStateModel extends ChangeNotifier {
  // in-memory expiration date
  DateTime accessTokenExpirationDateTime;
  // im-memory access token
  String accessToken;
  // Once logged in
  bool loggedInBefore;
}
