import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:spotifyflutterapp/data/models/auth.dart';
import 'package:spotifyflutterapp/util/constants.dart';

class ApiClient {
  // AppAuth for auth
  final FlutterAppAuth _appAuth;

  ApiClient(this._appAuth);

  // Receive the response which has an authorizationCode
  Future<AuthorizationResponse> exchangeAuthorizationCode(String clientId, String redirectUrl) async {
    return await _appAuth.authorize(
      AuthorizationRequest(
        clientId,
        redirectUrl,
        serviceConfiguration: AuthorizationServiceConfiguration(
            'https://accounts.spotify.com/authorize', 'https://accounts.spotify.com/api/token'),
        scopes: [
          'user-modify-playback-state',
          'user-library-modify',
          'playlist-read-private',
          'playlist-modify-public',
          'playlist-modify-private',
          'user-read-playback-state',
          'user-read-currently-playing'
        ],
      ),
    );
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of authorizationCode and codeVerifier
  Future<TokenResponse> exchangeToken(
      String authorizationCode, String codeVerifier, String clientId, String redirectUrl) async {
    return await _appAuth.token(
      TokenRequest(
        clientId,
        redirectUrl,
        serviceConfiguration: AuthorizationServiceConfiguration(
            'https://accounts.spotify.com/authorize', 'https://accounts.spotify.com/api/token'),
        authorizationCode: authorizationCode,
        codeVerifier: codeVerifier,
      ),
    );
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of refresh token
  Future<TokenResponse> refreshToken(String refreshToken, String clientId, String redirectUrl) async {
    // return await _appAuth.token(
    //   TokenRequest(
    //     clientId,
    //     redirectUrl,
    //     grantType: GrantType.refreshToken,
    //     serviceConfiguration: AuthorizationServiceConfiguration(
    //         'https://accounts.spotify.com/authorize', 'https://accounts.spotify.com/api/token'),
    //     refreshToken: refreshToken,
    //   ),
    // );

    // TODO: when trying to refresh token with AppAuth's API, "Concurrent operations detected" happens,
    // so, I'll let this the temporal implementation.

    final body = {
      'grant_type': GrantType.refreshToken,
      'refresh_token': refreshToken,
      'client_id': clientId,
    };

    final header = {'Content-Type': 'application/x-www-form-urlencoded'};

    final response = await http.post('https://accounts.spotify.com/api/token', body: body, headers: header);

    final resString = response.body;
    Map authMap = await jsonDecode(resString);
    final auth = Auth.fromJson(authMap);

    return TokenResponse(
      auth.accessToken,
      auth.refreshToken,
      DateTime.now().add(Duration(seconds: auth.expiresIn)),
      null,
      null,
      null,
    );
  }

  // request to get current user's list of playlist
  Future<http.Response> requestToGetPlaylists(Map<String, String> authHeader) async {
    return await http.get(
      Constants.current_users_playlists,
      headers: authHeader,
    );
  }

  // request to get tracks in a specific playlist
  Future<http.Response> requestToGetTracksInPlaylist(
    Map<String, String> authHeader,
    String url,
  ) async {
    return await http.get(
      url,
      headers: authHeader,
    );
  }

  // request to get current user's profile
  Future<http.Response> requestToGetCurrentUserProfile(Map<String, String> authHeader) async {
    return await http.get(
      Constants.current_users_profile,
      headers: authHeader,
    );
  }

  // request to get playlist name for a playlist id
  Future<http.Response> requestToGetPlaylistName(Map<String, String> authHeader, String playlistId) async {
    return await http.get(
      Constants.playlist_name_for_a_playlist_id(playlistId),
      headers: authHeader,
    );
  }

  // request to get playlist snapshot_id for a playlist id
  Future<http.Response> requestToGetPlaylistSnapshotId(Map<String, String> authHeader, String playlistId) async {
    return await http.get(
      Constants.playlist_snapshot_id_for_a_playlist_id(playlistId),
      headers: authHeader,
    );
  }
}
