class AppStateModel {
  // in-memory expiration date
  DateTime accessTokenExpirationDateTime;
  // im-memory access token
  String accessToken;
  // Once logged in
  bool loggedInBefore;
}