import 'dart:convert';
import 'dart:io';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotifyflutterapp/data/models/album.dart';
import 'package:spotifyflutterapp/data/models/albumInPlaylistPage.dart';
import 'package:spotifyflutterapp/data/models/paging.dart';
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
  Future<http.Response> requestToGetTracksInPlaylist(
    Map<String, String> authHeader,
    String url,
  ) async {
    return http.Response(Data.tracksInPlaylist, 200);
  }
}

void main() async {
  ApiService apiService;
  String option;
  // set up service for unit testing.

  Future<Album> createAlbumFromJsonFile(String path) async {
    final albumJson = File(path);
    final albumMap = await jsonDecode(await albumJson.readAsString());
    return Album.fromJson(albumMap);
  }

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
    final accessTokenExpirationDateTime = DateTime.now().add(const Duration(hours: 1));

    await _storage.storeDataToStorage(
        Constants.key_accessTokenExpirationDateTime, accessTokenExpirationDateTime.toString());
    await _storage.storeDataToStorage(Constants.key_accessToken, accessToken);
    await _storage.storeDataToStorage(Constants.key_refreshToken, refreshToken);

    await apiService.init();

    var playlistTracks = await apiService.getTracksInPlaylist('37i9dQZEVXcRTfRQrKqKRF');

    expect(apiService.accessToken, accessToken);
    expect(await apiService.refreshToken, refreshToken);
    expect(apiService.loggedInBefore, true);

    expect(playlistTracks, isInstanceOf<Paging<PlaylistTrack>>());
  });

  tearDown(() async {
    final _storage = FileStorage(option);

    await _storage.storeDataToStorage(Constants.key_accessToken, '');
    await _storage.storeDataToStorage(Constants.key_accessTokenExpirationDateTime, '');
    await _storage.storeDataToStorage(Constants.key_refreshToken, '');
  });

  test('receives a list of tracks and create a list of albums based on the track list.', () async {
    // source track list
    final file = File(option + 'test_resources/trackAggregationToAlbums/track_list.json');
    // expected album list
    var expectedAlbumList = <Album>[];
    Album album1 = await createAlbumFromJsonFile(option + 'test_resources/trackAggregationToAlbums/album1.json');
    Album album2 = await createAlbumFromJsonFile(option + 'test_resources/trackAggregationToAlbums/album2.json');
    Album album3 = await createAlbumFromJsonFile(option + 'test_resources/trackAggregationToAlbums/album3.json');
    Album album4 = await createAlbumFromJsonFile(option + 'test_resources/trackAggregationToAlbums/album4.json');
    expectedAlbumList.add(apiService.convertAlbumToAlbumInPlaylistPage(album1));
    expectedAlbumList.add(apiService.convertAlbumToAlbumInPlaylistPage(album2));
    expectedAlbumList.add(apiService.convertAlbumToAlbumInPlaylistPage(album3));
    expectedAlbumList.add(apiService.convertAlbumToAlbumInPlaylistPage(album4));

    Map pagingMap = await jsonDecode(await file.readAsString());
    Paging paging = Paging<PlaylistTrack>.fromJson(pagingMap, (items) => PlaylistTrack.fromJson(items));

    List<AlbumInPlaylistPage> albumList = await apiService.aggregateTracksToAlbums(
      paging.items,
    );

    // check the album ids.
    expect(albumList[0].id, expectedAlbumList[0].id);
    expect(albumList[1].id, expectedAlbumList[1].id);
    expect(albumList[2].id, expectedAlbumList[2].id);
    expect(albumList[3].id, expectedAlbumList[3].id);

    // check the number of tracks
    expect(albumList[0].numberOfTracks, 1);
    expect(albumList[1].numberOfTracks, 3);
    expect(albumList[2].numberOfTracks, 4);
    expect(albumList[3].numberOfTracks, 2);
  });

  test('merge created album list with the existing album list', () async {
    // source track list
    final file = File(option + 'test_resources/trackAggregationToAlbums/track_list.json');
    Map pagingMap = await jsonDecode(await file.readAsString());
    Paging paging = Paging<PlaylistTrack>.fromJson(pagingMap, (items) => PlaylistTrack.fromJson(items));
    List<AlbumInPlaylistPage> albumList = await apiService.aggregateTracksToAlbums(
      paging.items,
    );

    // merged track list
    final file2 = File(option + 'test_resources/trackAggregationToAlbums/track_list2.json');
    Map pagingMap2 = await jsonDecode(await file2.readAsString());
    Paging paging2 = Paging<PlaylistTrack>.fromJson(pagingMap2, (items) => PlaylistTrack.fromJson(items));
    List<AlbumInPlaylistPage> albumList2 = await apiService.aggregateTracksToAlbums(
      paging2.items,
    );

    // merge two album lists.
    List<AlbumInPlaylistPage> mergedAlbumList = apiService.mergeAlbumLists(merged: albumList, merge: albumList2);
    expect(mergedAlbumList[3].id, albumList2[0].id);
    expect(mergedAlbumList[3].numberOfTracks, 4);
  });

  test('in the case you just add album list at the end of the merged list.', () async {
    // source track list
    final file = File(option + 'test_resources/trackAggregationToAlbums/track_list.json');
    Map pagingMap = await jsonDecode(await file.readAsString());
    Paging paging = Paging<PlaylistTrack>.fromJson(pagingMap, (items) => PlaylistTrack.fromJson(items));
    List<AlbumInPlaylistPage> albumList = await apiService.aggregateTracksToAlbums(
      paging.items,
    );

    // merged track list
    final file3 = File(option + 'test_resources/trackAggregationToAlbums/track_list3.json');
    Map pagingMap3 = await jsonDecode(await file3.readAsString());
    Paging paging3 = Paging<PlaylistTrack>.fromJson(pagingMap3, (items) => PlaylistTrack.fromJson(items));
    List<AlbumInPlaylistPage> albumList3 = await apiService.aggregateTracksToAlbums(
      paging3.items,
    );

    // merge two album lists.
    List<AlbumInPlaylistPage> mergedAlbumList = apiService.mergeAlbumLists(merged: albumList, merge: albumList3);
    expect(mergedAlbumList[4].id, albumList3[0].id);
    expect(mergedAlbumList[3].numberOfTracks, 2);
    expect(mergedAlbumList[4].numberOfTracks, 1);
    expect(mergedAlbumList[5].numberOfTracks, 2);
  });
}
