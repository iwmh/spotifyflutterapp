import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotifyflutterapp/data/models/paging.dart';
import 'package:spotifyflutterapp/data/models/playlist.dart';
import 'package:spotifyflutterapp/data/repositories/api_auth_repository.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/repositories/secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/statemodels/app_state_model.dart';
import 'package:spotifyflutterapp/util/constants.dart';
import 'package:spotifyflutterapp/util/util.dart';
import 'package:http/http.dart' as http;

class ApiService extends ChangeNotifier {
  // repo for auth-related functionality
  final ApiAuthRepository _apiAuthRepository;
  // repo for securely store/read token data.
  final BaseSecureStorage _secureStorage;
  // application-level state
  AppStateModel _appState;

  // constructor
  ApiService(this._apiAuthRepository, this._secureStorage);

  // setter for appState
  set appState(AppStateModel appState) {
    _appState = appState;
  }

  // Public factory method
  static Future<ApiService> createApiAuthService() async {
    // get secrets from assets folder
    var secrets = await getSecretsFromAssets();

    // secure storage
    var storage = new FlutterSecureStorage();

    // init repo
    ApiAuthRepository apiAuthRepository =
        new ApiAuthRepository(secrets.clientId, secrets.redirectUrl);
    BaseSecureStorage secureStorage = new SecureStorage(storage);

    return ApiService(apiAuthRepository, secureStorage);
  }

  // some things to do when initialized
  Future<void> init() async {
    // read token info from storage and set them to the app-level state.
    var accessToken =
        await _secureStorage.readDataFromStorage(Constants.key_accessToken);
    var accessTokenExpirationDateTime = await _secureStorage
        .readDataFromStorage(Constants.key_accessTokenExpirationDateTime);
    _appState.accessToken = accessToken == null ? '' : accessToken;
    if (accessTokenExpirationDateTime != null) {
      _appState.accessTokenExpirationDateTime =
          DateTime.parse(accessTokenExpirationDateTime);
    }

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
      final accessTokenResult = await _apiAuthRepository.exchangeToken(
          authCodeResult.authorizationCode, authCodeResult.codeVerifier);
      if (accessTokenResult != null && accessTokenResult.accessToken != null) {
        /// 1) store all the info about the result.
        ///   access token
        ///   refresh token
        ///   access token expiration datetime
        /// 2) put access token and expiration datetime in-memory.
        _secureStorage.storeDataToStorage(
            Constants.key_accessToken, accessTokenResult.accessToken);
        _secureStorage.storeDataToStorage(
            Constants.key_refreshToken, accessTokenResult.refreshToken);
        _secureStorage.storeDataToStorage(
            Constants.key_accessTokenExpirationDateTime,
            accessTokenResult.accessTokenExpirationDateTime.toString());
        _appState.accessToken = accessTokenResult.accessToken;
        _appState.accessTokenExpirationDateTime =
            accessTokenResult.accessTokenExpirationDateTime;

        _appState.loggedInBefore = true;

        notifyListeners();
      }
    }
  }

  /// refresh accesss token
  refreshAccessToken() async {
    // get refresh token from storage
    final refreshToken =
        await _secureStorage.readDataFromStorage(Constants.key_refreshToken);
    final accessTokenResult =
        await _apiAuthRepository.refreshToken(refreshToken);
    if (accessTokenResult != null && accessTokenResult.accessToken != null) {
      _secureStorage.storeDataToStorage(
          Constants.key_accessToken, accessTokenResult.accessToken);
      _secureStorage.storeDataToStorage(
          Constants.key_refreshToken, accessTokenResult.refreshToken);
      _secureStorage.storeDataToStorage(
          Constants.key_accessTokenExpirationDateTime,
          accessTokenResult.accessTokenExpirationDateTime.toString());
      _appState.accessToken = accessTokenResult.accessToken;
      _appState.accessTokenExpirationDateTime =
          accessTokenResult.accessTokenExpirationDateTime;
    }
  }

  // delete storage data.
  // TODO: remove this method when releasing.
  deleteAllDataInStorage() async {
    await _secureStorage.deleteAllDataInStorage();
  }

  // get current user's list of playlist
  Future<List<Playlist>> getPlaylists() async {
    if (_appState.accessTokenExpirationDateTime.isAfter(DateTime.now())) {
      await refreshAccessToken();
    }

    var authHeader = {
      HttpHeaders.authorizationHeader: 'Bearer ' + _appState.accessToken
    };
    var response =
        await http.get(Constants.current_users_playlists, headers: authHeader);

    Map pagingMap = jsonDecode(response.body);
    Paging paging = Paging<Playlist>.fromJson(
        pagingMap, (items) => Playlist.fromJson(items));
    var playlists = paging.items;
    print('');
  }
}
