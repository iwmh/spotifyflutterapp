class Constants {
  // key for local storage.
  static const key_accessToken = "SSA_accessToken";
  static const key_refreshToken = "SSA_refreshToken";
  static const key_accessTokenExpirationDateTime = "SSA_accessTokenExpirationDateTime";
  static const key_currentUsersProfileDisplayName = "SSA_currentUsersProfileDisplayName";

  // URLs for API call.
  static const current_users_playlists = 'https://api.spotify.com/v1/me/playlists';
  static tracks_in_playlist(String playlistId) => 'https://api.spotify.com/v1/playlists/$playlistId/tracks?';

  /// "fields" query for [tracks_in_playlist] URL.
  static const albums = 'fields=items(added_at, track(album(artists, id, images, name, release_date))),next';

  static const current_users_profile = 'https://api.spotify.com/v1/me';

  // when you run tests from console.
  static const access_token_file = 'file_storage/key_accessToken.txt';

  static const accessTokenExpirationDateTime_file = 'file_storage/key_accessTokenExpirationDateTime.txt';

  static const refresh_token_file = 'file_storage/key_refreshToken.txt';
}
