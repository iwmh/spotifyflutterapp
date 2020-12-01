import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:spotifyflutterapp/data/repositories/api_client.dart';

class ApiAuthRepository {
  ApiClient _apiClient;
  String _clientId;
  String _redirectUrl;

  ApiAuthRepository(ApiClient apiClient, String clientId, String redirectUrl) {
    _apiClient = apiClient;
    _clientId = clientId;
    _redirectUrl = redirectUrl;
  }

  // Receive the response which has an authorizationCode
  Future<AuthorizationResponse> exchangeAuthorizationCode() async {
    return _apiClient.exchangeAuthorizationCode(_clientId, _redirectUrl);
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of authorizationCode and codeVerifier
  Future<TokenResponse> exchangeToken(String authorizationCode, String codeVerifier) async {
    return await _apiClient.exchangeToken(authorizationCode, codeVerifier, _clientId, _redirectUrl);
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of refresh token
  Future<TokenResponse> refreshToken(String refreshToken) async {
    return await _apiClient.refreshToken(refreshToken, _clientId, _redirectUrl);
  }

  // request to get current user's list of playlist
  Future<http.Response> requestToGetPlaylists(Map<String, String> authHeader) async {
    return await _apiClient.requestToGetPlaylists(authHeader);
  }
}
