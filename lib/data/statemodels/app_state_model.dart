class AppStateModel {
  // in-memory expiration date
  DateTime accessTokenExpirationDateTime = DateTime.now();
  // im-memory access token
  String accessToken = '';
  // Once logged in
  bool loggedInBefore = false;
}