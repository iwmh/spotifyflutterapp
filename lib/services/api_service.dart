import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotifyflutterapp/data/repositories/api_auth_repository.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/repositories/secure_storage_repository.dart';
import 'package:spotifyflutterapp/util/util.dart';

class ApiService {

  // repo for auth-related functionality
  final ApiAuthRepository _apiAuthRepository;
  // repo for securely store/read token data.
  final BaseSecureStorage _secureStorage;

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


  exchangeAuthorizationCode() async {
    final authCodeResult = await _apiAuthRepository.exchangeAuthorizationCode();
    if(authCodeResult != null && authCodeResult.authorizationCode != null){
      final accessTokenResult = await _apiAuthRepository.exchangeToken(authCodeResult.authorizationCode, authCodeResult.codeVerifier);
      print('');
    }
  }

}