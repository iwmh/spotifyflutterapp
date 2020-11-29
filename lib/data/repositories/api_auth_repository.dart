import 'package:flutter_appauth/flutter_appauth.dart';

class ApiAuthRepository {
  FlutterAppAuth _appAuth;
  String _clientId;
  String _redirectUrl;

  ApiAuthRepository(String clientId, String redirectUrl) {
    // initialize AppAuth for Flutter
    _appAuth = FlutterAppAuth();
    _clientId = clientId;
    _redirectUrl = redirectUrl;
  }

  // Receive the response which has an authorizationCode
  Future<AuthorizationResponse> exchangeAuthorizationCode() async {
    return await _appAuth.authorize(AuthorizationRequest(_clientId, _redirectUrl,
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
  Future<TokenResponse> exchangeToken(String authorizationCode, String codeVerifier) async {
    return await _appAuth.token(
      TokenRequest(_clientId, _redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
              'https://accounts.spotify.com/authorize', 'https://accounts.spotify.com/api/token'),
          authorizationCode: authorizationCode,
          codeVerifier: codeVerifier),
    );
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of refresh token
  Future<TokenResponse> refreshToken(String refreshToken) async {
    return await _appAuth.token(
      TokenRequest(_clientId, _redirectUrl,
          serviceConfiguration: AuthorizationServiceConfiguration(
              'https://accounts.spotify.com/authorize', 'https://accounts.spotify.com/api/token'),
          refreshToken: refreshToken),
    );
  }
}
