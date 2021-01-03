import 'dart:convert';
import 'dart:io';

import 'package:spotifyflutterapp/data/models/paging.dart';
import 'package:spotifyflutterapp/data/models/playlist.dart';
import 'package:spotifyflutterapp/data/models/playlist_track.dart';
import 'package:spotifyflutterapp/data/models/profile.dart';
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
    var now = new DateTime.now();
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
  Future<List<PlaylistTrack>> getTracksInPlaylist(String playlistId) async {
    List<PlaylistTrack> ret;
    // check token
    await checkTokenValidity();
    // call api.
    await _apiAuthRepository.requestToGetTracksInPlaylist(_authHeader(), playlistId).then((response) {
      Map pagingMap = jsonDecode(response.body);
      Paging paging = Paging<PlaylistTrack>.fromJson(pagingMap, (items) => PlaylistTrack.fromJson(items));
      ret = paging.items;
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
}
