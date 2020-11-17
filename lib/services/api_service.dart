import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotifyflutterapp/data/repositories/api_auth_repository.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/repositories/secure_storage_repository.dart';
import 'package:spotifyflutterapp/util/constants.dart';
import 'package:spotifyflutterapp/util/util.dart';

class ApiService {

  // repo for auth-related functionality
  final ApiAuthRepository _apiAuthRepository;
  // repo for securely store/read token data.
  final BaseSecureStorage _secureStorage;
  // in-memory expiration date
  DateTime _accessTokenExpirationDateTime;
  // im-memory access token
  String _accessToken;

  ApiService(this._apiAuthRepository, this._secureStorage);

  // Public factory method
  static Future<ApiService> createApiAuthService() async {
    // get secrets from assets folder
    var secrets = await getSecretsFromAssets();

    // secure storage
    var storage = new FlutterSecureStorage();

    // init repo
    ApiAuthRepository apiAuthRepository = new ApiAuthRepository(secrets.clientId, secrets.redirectUrl);
    BaseSecureStorage secureStorage = new SecureStorage(storage);

    return ApiService(apiAuthRepository, secureStorage);
  }
  
  /// Exchange authorization code and exchange it with access token.
  exchangeAuthorizationCodeAndAccessToken() async {
    // receive a result with authorization code
    final authCodeResult = await _apiAuthRepository.exchangeAuthorizationCode();
    if(authCodeResult != null && authCodeResult.authorizationCode != null){
      // receive a result with access token 
      final accessTokenResult = await _apiAuthRepository.exchangeToken(authCodeResult.authorizationCode, authCodeResult.codeVerifier);
      if(accessTokenResult != null && accessTokenResult.accessToken != null){
        /// 1) store all the info about the result.
        ///   access token
        ///   refresh token
        ///   access token expiration datetime
        /// 2) put access token and expiration datetime in-memory.
        _secureStorage.storeDataToStorage(Constants.key_accessToken, accessTokenResult.accessToken);
        _secureStorage.storeDataToStorage(Constants.key_refreshToken, accessTokenResult.refreshToken);
        _secureStorage.storeDataToStorage(Constants.key_accessTokenExpirationDateTime, accessTokenResult.accessTokenExpirationDateTime.toString());
        _accessToken = accessTokenResult.accessToken;
        _accessTokenExpirationDateTime = accessTokenResult.accessTokenExpirationDateTime;
      }
    }
  }

  Future<bool> isLoggedIn() async {
    var accessToken = await _secureStorage.readDataFromStorage(Constants.key_accessToken);
    var refreshToken = await _secureStorage.readDataFromStorage(Constants.key_refreshToken);
    var accessTokenExpirationDateTime = await _secureStorage.readDataFromStorage(Constants.key_accessTokenExpirationDateTime);

    if(accessToken == null || refreshToken == null || accessTokenExpirationDateTime == null)
      return false;

    return accessToken.isNotEmpty && refreshToken.isNotEmpty && accessTokenExpirationDateTime.isNotEmpty;
  }

  deleteAllDataInStorage() async {
    await _secureStorage.deleteAllDataInStorage();
  }

}