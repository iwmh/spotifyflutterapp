import 'dart:io';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotifyflutterapp/data/models/playlist.dart';
import 'package:spotifyflutterapp/data/models/playlist_track.dart';
import 'package:spotifyflutterapp/data/models/secrets.dart';
import 'package:spotifyflutterapp/data/repositories/api_auth_repository.dart';
import 'package:spotifyflutterapp/data/repositories/api_client.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/util/constants.dart';
import 'package:http/http.dart' as http;

import 'data.dart';
import 'repositories/file_storage_repository.dart';

class MockApiClient extends Mock implements ApiClient {
  static String exchangedAccessToken = "ExchangedAccessToken";
  static String exchangedRefreshToken = "ExchangedRefreshToken";
  static String refreshedAccessToken = "RefreshedAccessToken";
  static String refreshedRefreshToken = "RefreshedRefreshToken";

  // Receive the response which has an authorizationCode
  @override
  Future<AuthorizationResponse> exchangeAuthorizationCode(String clientId, String redirectUrl) async {
    return AuthorizationResponse("AuthorizationCode", "CodeVerifier", <String, String>{});
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of authorizationCode and codeVerifier
  @override
  Future<TokenResponse> exchangeToken(
      String authorizationCode, String codeVerifier, String clientId, String redirectUrl) async {
    return TokenResponse(
      exchangedAccessToken,
      exchangedRefreshToken,
      DateTime.now().add(const Duration(hours: 1)),
      "",
      "",
      <String, String>{},
    );
  }

  // Receive the response which has a pair of accessToken and refreshToken
  // in exchange of refresh token
  @override
  Future<TokenResponse> refreshToken(String refreshToken, String clientId, String redirectUrl) async {
    return TokenResponse(
      refreshedAccessToken,
      refreshedRefreshToken,
      DateTime.now().add(const Duration(hours: 1)),
      "",
      "",
      <String, String>{},
    );
  }

  // request to get current user's list of playlist
  @override
  Future<http.Response> requestToGetPlaylists(Map<String, String> authHeader) async {
    return http.Response(
      Data.playlistsData,
      200,
    );
  }

  // request to get tracks in a specific playlist
  @override
  Future<http.Response> requestToGetTracksInPlaylist(Map<String, String> authHeader, String playlistId) async {
    return http.Response(Data.tracksInPlaylist, 200);
  }
}

void main() async {
  ApiService apiService;
  var option;
  // set up service for unit testing.
  setUp(() async {
    var secrets = Secrets('', '');
    if (Directory.current.path.endsWith('t')) {
      option = '../test/';
    } else {
      option = 'test/';
    }

    // api client for testing
    final apiClient = MockApiClient();

    // inittialize repositories
    ApiAuthRepository apiAuthRepository = ApiAuthRepository(apiClient, secrets.clientId, secrets.redirectUrl);
    BaseSecureStorageRepository secureStorageRepository = FileStorage(option);

    // create service
    apiService = ApiService(apiAuthRepository, secureStorageRepository);

    final _storage = FileStorage(option);

    await _storage.storeDataToStorage(Constants.key_accessToken, '');
    await _storage.storeDataToStorage(Constants.key_accessTokenExpirationDateTime, '');
    await _storage.storeDataToStorage(Constants.key_refreshToken, '');
  });
  // access token not being stored.
  test('init with no token related info stored, therefore not loggedInBefore.', () async {
    await apiService.init();
    expect(apiService.accessToken, null);
    expect(apiService.accessTokenExpirationDateTime, null);
    expect(apiService.loggedInBefore, false);
  });

  test('init with token related info stored, therefore loggedInBefore.', () async {
    final _storage = FileStorage(option);
    const accessToken = 'sakjlfaIkjf978kj';
    final accessTokenExpirationDateTime = DateTime.parse('1992-05-02 20:18:00');
    await _storage.storeDataToStorage(Constants.key_accessToken, accessToken);
    await _storage.storeDataToStorage(
        Constants.key_accessTokenExpirationDateTime, accessTokenExpirationDateTime.toString());

    await apiService.init();
    expect(apiService.accessToken, accessToken);
    expect(apiService.accessTokenExpirationDateTime, accessTokenExpirationDateTime);
    expect(apiService.loggedInBefore, true);
  });

  test('init with access token stored, but expirationdatetime missing, wherefore not loggedInBefore.', () async {
    final _storage = FileStorage(option);
    const accessToken = 'sakjlfaIkjf978kj';
    await _storage.storeDataToStorage(Constants.key_accessToken, accessToken);

    await apiService.init();
    expect(apiService.accessToken, accessToken);
    expect(apiService.loggedInBefore, false);
  });

  test('init with expirationdatetime stored, but accessToken missing, wherefore not loggedInBefore.', () async {
    final _storage = FileStorage(option);
    const accessToken = 'sakjlfaIkjf978kj';
    final accessTokenExpirationDateTime = DateTime.parse('1992-05-02 20:18:00');
    await _storage.storeDataToStorage(Constants.key_accessToken, accessToken);
    await _storage.storeDataToStorage(
        Constants.key_accessTokenExpirationDateTime, accessTokenExpirationDateTime.toString());

    await apiService.init();
    expect(apiService.accessToken, accessToken);
    expect(apiService.accessTokenExpirationDateTime, accessTokenExpirationDateTime);
    expect(apiService.loggedInBefore, true);
  });

  test('exchange authorizationCode with accessToken.', () async {
    await apiService.init();

    // exchange authCode
    await apiService.exchangeAuthorizationCodeAndAccessToken();

    expect(apiService.accessToken, MockApiClient.exchangedAccessToken);
    //expect(apiService.accessToken, MockApiClient.exchangedAccessToken);
    expect(await apiService.refreshToken, MockApiClient.exchangedRefreshToken);
    expect(apiService.loggedInBefore, true);
  });

  test('exchange authorizationCode with accessToken, then refreshToken', () async {
    await apiService.init();

    // exchange authCode
    await apiService.exchangeAuthorizationCodeAndAccessToken();

    // refresh token
    await apiService.refreshAccessToken();

    expect(apiService.accessToken, MockApiClient.refreshedAccessToken);
    //expect(apiService.accessToken, MockApiClient.exchangedAccessToken);
    expect(await apiService.refreshToken, MockApiClient.refreshedRefreshToken);
    expect(apiService.loggedInBefore, true);
  });

  test('access token expired, therefore reshresh token.', () async {
    final _storage = FileStorage(option);
    const accessToken = 'sakjlfaIkjf978kj';
    final accessTokenExpirationDateTime = DateTime.now().add(const Duration(seconds: -10));
    await _storage.storeDataToStorage(Constants.key_accessToken, accessToken);
    await _storage.storeDataToStorage(
        Constants.key_accessTokenExpirationDateTime, accessTokenExpirationDateTime.toString());

    await apiService.init();

    await apiService.checkTokenValidity();

    expect(apiService.accessToken, MockApiClient.refreshedAccessToken);
    expect(await apiService.refreshToken, MockApiClient.refreshedRefreshToken);
    expect(apiService.loggedInBefore, true);
  });

  test('access token NOT expired, therefore NOT reshresh token.', () async {
    final _storage = FileStorage(option);
    const accessToken = 'sakjlfaIkjf978kj';
    const refreshToken = 'v,msdfkjlnrkjljk';
    final accessTokenExpirationDateTime = DateTime.now().add(const Duration(hours: 1));
    await _storage.storeDataToStorage(Constants.key_accessToken, accessToken);
    await _storage.storeDataToStorage(Constants.key_refreshToken, refreshToken);
    await _storage.storeDataToStorage(
        Constants.key_accessTokenExpirationDateTime, accessTokenExpirationDateTime.toString());

    await apiService.init();

    await apiService.checkTokenValidity();

    expect(apiService.accessToken, accessToken);
    expect(await apiService.refreshToken, refreshToken);
    expect(apiService.accessTokenExpirationDateTime, accessTokenExpirationDateTime);
    expect(apiService.loggedInBefore, true);
  });

  test('get playlists successfully, after refreshing token.', () async {
    final _storage = FileStorage(option);
    const accessToken = 'sakjlfaIkjf978kj';
    const refreshToken = 'v,msdfkjlnrkjljk';
    final accessTokenExpirationDateTime = DateTime.now().add(const Duration(seconds: -10));
    await _storage.storeDataToStorage(Constants.key_accessToken, accessToken);
    await _storage.storeDataToStorage(Constants.key_refreshToken, refreshToken);
    await _storage.storeDataToStorage(
        Constants.key_accessTokenExpirationDateTime, accessTokenExpirationDateTime.toString());

    await apiService.init();

    var playlists = await apiService.getPlaylists();

    expect(apiService.accessToken, MockApiClient.refreshedAccessToken);
    expect(await apiService.refreshToken, MockApiClient.refreshedRefreshToken);
    expect(apiService.loggedInBefore, true);

    expect(playlists, isInstanceOf<List<Playlist>>());
  });
  test('get tracks in playlist successfully', () async {
    final _storage = FileStorage(option);
    const accessToken = 'sakjlfaIkjf978kj';
    const refreshToken = 'v,msdfkjlnrkjljk';
    await _storage.storeDataToStorage(Constants.key_accessToken, accessToken);
    await _storage.storeDataToStorage(Constants.key_refreshToken, refreshToken);

    await apiService.init();

    var playlistTracks = await apiService.getTracksInPlaylist('37i9dQZEVXcRTfRQrKqKRF');

    expect(apiService.accessToken, accessToken);
    expect(await apiService.refreshToken, refreshToken);
    expect(apiService.loggedInBefore, true);

    expect(playlistTracks, isInstanceOf<List<PlaylistTrack>>());
  });

  tearDown(() async {
    final _storage = FileStorage(option);

    await _storage.storeDataToStorage(Constants.key_accessToken, '');
    await _storage.storeDataToStorage(Constants.key_accessTokenExpirationDateTime, '');
    await _storage.storeDataToStorage(Constants.key_refreshToken, '');
  });
}
