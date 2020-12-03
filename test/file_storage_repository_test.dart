import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'repositories/file_storage_repository.dart';
import 'package:spotifyflutterapp/util/constants.dart';

void main() {
  var _storage;

  setUp(() {
    var option;
    if (Directory.current.path.endsWith('t')) {
      option = '..\\test\\';
    } else {
      option = 'test\\';
    }
    _storage = new FileStorage(option);
  });
  test('save/read data to/from key_accessToken file.', () async {
    var data = 'access token';
    await _storage.storeDataToStorage(Constants.key_accessToken, data);
    var value = await _storage.readDataFromStorage(Constants.key_accessToken);
    expect(value, data);
  });

  test('save/read data to/from key_accessTokenExpirationDateTime file.', () async {
    var data = 'access token expiration date time';
    await _storage.storeDataToStorage(Constants.key_accessTokenExpirationDateTime, data);
    var value = await _storage.readDataFromStorage(Constants.key_accessTokenExpirationDateTime);
    expect(value, data);
  });

  test('save/read data to/from key_refreshToken file.', () async {
    var data = 'refresh token';
    await _storage.storeDataToStorage(Constants.key_refreshToken, data);
    var value = await _storage.readDataFromStorage(Constants.key_refreshToken);
    expect(value, data);
  });

  tearDown(() async {
    await _storage.storeDataToStorage(Constants.key_accessToken, '');
    await _storage.storeDataToStorage(Constants.key_accessTokenExpirationDateTime, '');
    await _storage.storeDataToStorage(Constants.key_refreshToken, '');
  });
}
