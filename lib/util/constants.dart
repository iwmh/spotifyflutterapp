class Constants {
  // key for local storage.
  static const key_accessToken = "SSA_accessToken";
  static const key_refreshToken = "SSA_refreshToken";
  static const key_accessTokenExpirationDateTime = "SSA_accessTokenExpirationDateTime";

  // URLs for API call.
  static const current_users_playlists = 'https://api.spotify.com/v1/me/playlists';

  // when you run tests from console.
  static const access_token_file = 'file_storage/key_accessToken.txt';

  static const accessTokenExpirationDateTime_file = 'file_storage/key_accessTokenExpirationDateTime.txt';

  static const refresh_token_file = 'file_storage/key_refreshToken.txt';
}
