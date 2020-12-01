import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:spotifyflutterapp/util/constants.dart';

class ApiClient {
  // AppAuth for auth
  FlutterAppAuth _appAuth;

  ApiClient(this._appAuth);

  // Receive the response which has an authorizationCode
  Future<AuthorizationResponse> exchangeAuthorizationCode(String clientId, String redirectUrl) async {
    return await _appAuth.authorize(AuthorizationRequest(clientId, redirectUrl,
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
        ]));
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of authorizationCode and codeVerifier
  Future<TokenResponse> exchangeToken(
      String authorizationCode, String codeVerifier, String clientId, String redirectUrl) async {
    return await _appAuth.token(
      TokenRequest(clientId, redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
              'https://accounts.spotify.com/authorize', 'https://accounts.spotify.com/api/token'),
          authorizationCode: authorizationCode,
          codeVerifier: codeVerifier),
    );
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of refresh token
  Future<TokenResponse> refreshToken(String refreshToken, String clientId, String redirectUrl) async {
    return await _appAuth.token(
      TokenRequest(clientId, redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
              'https://accounts.spotify.com/authorize', 'https://accounts.spotify.com/api/token'),
          refreshToken: refreshToken),
    );
  }

  // request to get current user's list of playlist
  Future<http.Response> requestToGetPlaylists(Map<String, String> authHeader) async {
    return await http.get(Constants.current_users_playlists, headers: authHeader);
  }
}