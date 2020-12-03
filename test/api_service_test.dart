import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotifyflutterapp/data/models/secrets.dart';
import 'package:spotifyflutterapp/data/repositories/api_auth_repository.dart';
import 'package:spotifyflutterapp/data/repositories/api_client.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/data/repositories/secure_storage_repository.dart';
import 'package:spotifyflutterapp/services/api_service.dart';
import 'package:spotifyflutterapp/util/constants.dart';

import 'repositories/file_storage_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  ApiService apiService;
  var option;
  // set up service for unit testing.
  setUp(() {
    var secrets = new Secrets('', '');
    if (Directory.current.path.endsWith('t')) {
      option = '..\\test\\';
    } else {
      option = 'test\\';
    }

    // api client for testing
    final apiClient = new MockApiClient();

    // inittialize repositories
    ApiAuthRepository apiAuthRepository = new ApiAuthRepository(apiClient, secrets.clientId, secrets.redirectUrl);
    BaseSecureStorageRepository secureStorageRepository = new FileStorage(option);

    // create service
    apiService = new ApiService(apiAuthRepository, secureStorageRepository);
  });
  // access token not being stored.
  test('no token related info stored, therefore not loggedInBefore.', () async {
    await apiService.init();
    expect(apiService.accessToken, null);
    expect(apiService.accessTokenExpirationDateTime, null);
    expect(apiService.loggedInBefore, false);
  });

  tearDown(() async {
    final _storage = new FileStorage(option);

    await _storage.storeDataToStorage(Constants.key_accessToken, '');
    await _storage.storeDataToStorage(Constants.key_accessTokenExpirationDateTime, '');
    await _storage.storeDataToStorage(Constants.key_refreshToken, '');
  });
}
