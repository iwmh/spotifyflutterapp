import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:spotifyflutterapp/data/models/album.dart';
import 'package:spotifyflutterapp/data/models/albumInPlaylistPage.dart';
import 'package:spotifyflutterapp/data/models/paging.dart';
import 'package:spotifyflutterapp/data/models/playlist.dart';
import 'package:spotifyflutterapp/data/models/playlist_track.dart';
import 'package:spotifyflutterapp/data/models/profile.dart';
import 'package:spotifyflutterapp/data/models/snapshot_id.dart';
import 'package:spotifyflutterapp/data/repositories/api_auth_repository.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/statemodels/app_state_model.dart';
import 'package:spotifyflutterapp/util/constants.dart';

class ApiService {
  // repo for auth-related functionality
  final ApiAuthRepository _apiAuthRepository;
  // repo for securely store/read token data.
  final BaseSecureStorageRepository _secureStorage;
  // application-level state
  AppStateModel _appState = AppStateModel();

  // getter of _appState values.
  get accessToken => _appState.accessToken;
  get accessTokenExpirationDateTime => _appState.accessTokenExpirationDateTime;
  get loggedInBefore => _appState.loggedInBefore;
  get displayName => _appState.displayName;

  get refreshToken async => await _secureStorage.readDataFromStorage(Constants.key_refreshToken);

  // constructor
  ApiService(this._apiAuthRepository, this._secureStorage);

  // setter for appState
  set appState(AppStateModel appState) {
    _appState = appState;
  }

  // create authHeader.
  Map<String, String> _authHeader() {
    return {HttpHeaders.authorizationHeader: 'Bearer ' + _appState.accessToken};
  }

  // check token expiration and refresh token if token expired.
  checkTokenValidity() async {
    var now = DateTime.now();
    var expirationDateTime = _appState.accessTokenExpirationDateTime;
    if (now.isAfter(expirationDateTime)) {
      await refreshAccessToken();
    }
  }

  // some things to do when initialized
  Future<void> init() async {
    // read token info from storage and set them to the app-level state.
    var accessToken = await _secureStorage.readDataFromStorage(Constants.key_accessToken);
    var accessTokenExpirationDateTime =
        await _secureStorage.readDataFromStorage(Constants.key_accessTokenExpirationDateTime);
    _appState.accessToken = accessToken;
    if (accessTokenExpirationDateTime != null) {
      _appState.accessTokenExpirationDateTime = DateTime.parse(accessTokenExpirationDateTime);
    }
    // ...also read display name
    final displayName = await _secureStorage.readDataFromStorage(Constants.key_currentUsersProfileDisplayName);
    _appState.displayName = displayName;

    // if either if them is missing, we regard the user as
    // having not been logged in before.
    if (accessToken == null || accessTokenExpirationDateTime == null) {
      _appState.loggedInBefore = false;
    } else if (accessToken.isEmpty || accessTokenExpirationDateTime.isEmpty) {
      _appState.loggedInBefore = false;
    } else {
      _appState.loggedInBefore = true;
    }
  }

  // If the user has logged in before.
  // you are going to set this value when the user authorize again
  // because the stored token is missing.
  bool hasLoggedInBefore() {
    return _appState.loggedInBefore;
  }

  /// Exchange authorization code and exchange it with access token.
  exchangeAuthorizationCodeAndAccessToken() async {
    // receive a result with authorization code
    final authCodeResult = await _apiAuthRepository.exchangeAuthorizationCode();
    if (authCodeResult != null && authCodeResult.authorizationCode != null) {
      // receive a result with access token
      final accessTokenResult =
          await _apiAuthRepository.exchangeToken(authCodeResult.authorizationCode, authCodeResult.codeVerifier);
      if (accessTokenResult != null && accessTokenResult.accessToken != null) {
        /// 1) store all the info about the result.
        ///   access token
        ///   refresh token
        ///   access token expiration datetime
        /// 2) put access token and expiration datetime in-memory.
        await _secureStorage.storeDataToStorage(Constants.key_accessToken, accessTokenResult.accessToken);
        await _secureStorage.storeDataToStorage(Constants.key_refreshToken, accessTokenResult.refreshToken);
        await _secureStorage.storeDataToStorage(
            Constants.key_accessTokenExpirationDateTime, accessTokenResult.accessTokenExpirationDateTime.toString());
        _appState.accessToken = accessTokenResult.accessToken;
        _appState.accessTokenExpirationDateTime = accessTokenResult.accessTokenExpirationDateTime;

        _appState.loggedInBefore = true;
      }
    }
  }

  // make a request to get the current user's profile
  // and save it to the storage.
  getAndStoreCurrentUserProdile() async {
    // get current user's profile and save its display name.
    final profile = await getCurrentUserProfile();
    await _secureStorage.storeDataToStorage(Constants.key_currentUsersProfileDisplayName, profile.displayName);
    _appState.displayName = profile.displayName;
  }

  /// refresh accesss token
  refreshAccessToken() async {
    // get refresh token from storage
    final refreshToken = await _secureStorage.readDataFromStorage(Constants.key_refreshToken);
    final accessTokenResult = await _apiAuthRepository.refreshToken(refreshToken);
    if (accessTokenResult != null && accessTokenResult.accessToken != null) {
      await _secureStorage.storeDataToStorage(Constants.key_accessToken, accessTokenResult.accessToken);
      await _secureStorage.storeDataToStorage(Constants.key_refreshToken, accessTokenResult.refreshToken);
      await _secureStorage.storeDataToStorage(
          Constants.key_accessTokenExpirationDateTime, accessTokenResult.accessTokenExpirationDateTime.toString());
      _appState.accessToken = accessTokenResult.accessToken;
      _appState.accessTokenExpirationDateTime = accessTokenResult.accessTokenExpirationDateTime;
    }
  }

  // delete storage data.
  // TODO: remove this method when releasing.
  deleteAllDataInStorage() async {
    _appState.accessToken = '';
    _appState.loggedInBefore = false;
    await _secureStorage.deleteAllDataInStorage();
  }

  // get current user's list of playlist
  Future<List<Playlist>> getPlaylists() async {
    List<Playlist> ret;
    // check token
    await checkTokenValidity();
    // call api.
    await _apiAuthRepository.requestToGetPlaylists(_authHeader()).then((response) {
      Map pagingMap = jsonDecode(response.body);
      Paging paging = Paging<Playlist>.fromJson(pagingMap, (items) => Playlist.fromJson(items));
      ret = paging.items;
    }).catchError((err) {
      // network related error.
      return err;
    });
    return ret;
  }

  // get tracks in a specific playlist
  Future<Paging> getTracksInPlaylist(String url) async {
    Paging ret;
    // check token
    await checkTokenValidity();
    // call api.
    await _apiAuthRepository.requestToGetTracksInPlaylist(_authHeader(), url).then((response) {
      Map pagingMap = jsonDecode(response.body);
      Paging paging = Paging<PlaylistTrack>.fromJson(pagingMap, (items) => PlaylistTrack.fromJson(items));
      ret = paging;
    }).catchError((err) {
      // network related error.
      return err;
    });
    return ret;
  }

  // get current user's profile
  Future<Profile> getCurrentUserProfile() async {
    Profile ret;
    // check token
    await checkTokenValidity();
    // call api.
    await _apiAuthRepository.requestToGetCurrentUserProfile(_authHeader()).then((response) {
      Map pagingMap = jsonDecode(response.body);
      ret = Profile.fromJson(pagingMap);
    }).catchError((err) {
      // network related error.
      return err;
    });
    return ret;
  }

  // get the playlist name for a playlistId
  Future<Playlist> getPlaylistName(String playlistId) async {
    Playlist ret;
    // check token
    await checkTokenValidity();
    // call api.
    await _apiAuthRepository.requestToGetPlaylistName(_authHeader(), playlistId).then((response) {
      Map pagingMap = jsonDecode(response.body);
      ret = Playlist.fromJson(pagingMap);
    }).catchError((err) {
      // network related error.
      return err;
    });
    return ret;
  }

  // get the playlist snapshot_id for a playlistId
  Future<Playlist> getPlaylistSnapshotId(String playlistId) async {
    Playlist ret;
    // check token
    await checkTokenValidity();
    // call api.
    await _apiAuthRepository.requestToGetPlaylistSnapshotId(_authHeader(), playlistId).then((response) {
      Map pagingMap = jsonDecode(response.body);
      ret = Playlist.fromJson(pagingMap);
    }).catchError((err) {
      // network related error.
      return err;
    });
    return ret;
  }

  // request to reorder or replace a playlists's items
  Future<SnapshotId> requestToReorderReplacePlaylistItems(String playlistId, HashMap requestBody) async {
    SnapshotId ret;
    // check token
    await checkTokenValidity();
    // call api.
    await _apiAuthRepository.requestToGetPlaylistSnapshotId(_authHeader(), playlistId).then((response) {
      Map pagingMap = jsonDecode(response.body);
      ret = SnapshotId.fromJson(pagingMap);
    }).catchError((err) {
      // network related error.
      return err;
    });
    return ret;
  }

  // takes the list of tracks and aggregate them to albums.
  aggregateTracksToAlbums(List<PlaylistTrack> fetchedList) {
    String albumIdToCompare;
    final albums = <AlbumInPlaylistPage>[];
    var numberOfTracks = 1;
    for (var i = 0; i < fetchedList.length; i++) {
      // First, you group the tracks which have the same album id.
      PlaylistTrack currentPlaylistTrack = fetchedList[i];
      // in the first iteration you just set albumId and regard it as representative
      // because you have no track to compare its albumId.
      if (i == 0) {
        albumIdToCompare = currentPlaylistTrack.track.album.id;
        final convertedAlbum = convertAlbumToAlbumInPlaylistPage(currentPlaylistTrack.track.album);
        albums.add(convertedAlbum);
        continue;
      } else {
        // Compare the albumId you kept with the current tracks albumId.
        // If you have the same albumId's track, then it means you are still
        // in between the tracks that need to be grouped as an album.
        if (albumIdToCompare == currentPlaylistTrack.track.album.id) {
          numberOfTracks++;
        } else {
          // Otherwise, rename albumIdToCompare and make that track as representative.
          // ... and set the numberOfTracks to the previous album.
          albums.last.numberOfTracks = numberOfTracks;

          albumIdToCompare = currentPlaylistTrack.track.album.id;
          final convertedAlbum = convertAlbumToAlbumInPlaylistPage(currentPlaylistTrack.track.album);
          albums.add(convertedAlbum);

          // reset the number.
          numberOfTracks = 1;
        }

        // record the number of tracks in the middle of the aggregation.
        if (i == fetchedList.length - 1) {
          albums.last.numberOfTracks = numberOfTracks;
          albums.last.numberOfTracksOnAggregating = numberOfTracks;
        }
        continue;
      }
    }
    return albums;
  }

  AlbumInPlaylistPage convertAlbumToAlbumInPlaylistPage(Album album) {
    return AlbumInPlaylistPage(
      albumType: album.albumType,
      artists: album.artists,
      availableMarkets: album.availableMarkets,
      externalUrls: album.externalUrls,
      href: album.href,
      id: album.id,
      images: album.images,
      name: album.name,
      releaseDate: album.releaseDate,
      releaseDatePrecision: album.releaseDatePrecision,
      totalTracks: album.totalTracks,
      type: album.type,
      uri: album.uri,
    );
  }

  List<AlbumInPlaylistPage> mergeAlbumLists({
    List<AlbumInPlaylistPage> merged,
    List<AlbumInPlaylistPage> merge,
  }) {
    final mergedAlbumList = <AlbumInPlaylistPage>[];
    mergedAlbumList.addAll(merged);
    if (mergedAlbumList.isEmpty) {
      mergedAlbumList.addAll(merge);
    } else {
      // Merge the tracks
      if (mergedAlbumList.last.id == merge.first.id) {
        final countToAdd = mergedAlbumList.last.numberOfTracksOnAggregating;
        mergedAlbumList.removeLast();
        merge.first.numberOfTracks += countToAdd;
        mergedAlbumList.addAll(merge);
      } else {
        mergedAlbumList.last.numberOfTracks = mergedAlbumList.last.numberOfTracksOnAggregating;
        mergedAlbumList.addAll(merge);
      }
    }
    return mergedAlbumList;
  }

  int determineStartingIndexToReorder(List<AlbumInPlaylistPage> albumList, int oldIndex) {
    var targetIndex = 0;
    for (int i = 0; i < oldIndex; i++) {
      final currentAlbum = albumList[i];
      targetIndex += currentAlbum.numberOfTracks;
    }
    return targetIndex;
  }

  Future<SnapshotId> reorderItemsInPlaylist(
    String playlistId,
    dynamic reqBody,
  ) async {
    SnapshotId ret;
    // check token
    await checkTokenValidity();
    // call api.
    await _apiAuthRepository.requestToReorderItemsInPlaylist(_authHeader(), playlistId, reqBody).then((response) {
      if (response.statusCode != HttpStatus.ok) {
        throw Exception(response);
      }
      Map pagingMap = jsonDecode(response.body);
      ret = SnapshotId.fromJson(pagingMap);
    }).catchError((err) {
      // network related error.
      return err;
    });
    return ret;
  }

  List<AlbumInPlaylistPage> reorderList({
    List<AlbumInPlaylistPage> albumList,
    int oldIndex,
    int newIndex,
  }) {
    if (oldIndex == newIndex) {
      throw Exception('Invalid parameters');
    }

    // copy the original list.
    List<AlbumInPlaylistPage> currentList = [...albumList];

    // extract the album to put between albums.
    final albumToAdd = albumList[oldIndex];

    // remove the album at the old index;
    currentList.removeAt(oldIndex);

    currentList.insert(newIndex, albumToAdd);
    return currentList;
  }
}
