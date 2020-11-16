import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotifyflutterapp/data/repositories/api_auth_repository.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/repositories/secure_storage_repository.dart';
import 'package:spotifyflutterapp/util/util.dart';

class ApiAuthService {

  final ApiAuthRepository _apiAuthRepository;
  final BaseSecureStorage _secureStorage;

  ApiAuthService(this._apiAuthRepository, this._secureStorage);

  // Public factory method
  static Future<ApiAuthService> createApiAuthService() async {
    // get secrets from assets folder
    var secrets = await getSecretsFromAssets();

    // secure storage
    var storage = new FlutterSecureStorage();

    // init repo
    ApiAuthRepository apiAuthRepository = new ApiAuthRepository(secrets.clientId, secrets.redirectUrl);
    BaseSecureStorage secureStorage = new SecureStorage(storage);

    return ApiAuthService(apiAuthRepository, secureStorage);
  }

  exchangeAuthorizationCode() async {
    final authCodeResult = await _apiAuthRepository.exchangeAuthorizationCode();
    if(authCodeResult != null){
      final accessTokenResult = await _apiAuthRepository.exchangeToken(authCodeResult.authorizationCode, authCodeResult.codeVerifier);
      print('');
    }
  }

}