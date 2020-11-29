import 'dart:io';

import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/util/constants.dart';

class FileStorage implements BaseSecureStorage {
  String option;
  FileStorage([this.option = '']);

  @override
  Future<String> readDataFromStorage(String key) async {
    switch (key) {
      case Constants.key_accessToken:
        final file = new File(option + Constants.access_token_file);
        return file.readAsString();
      case Constants.key_accessTokenExpirationDateTime:
        final file = new File(option + Constants.accessTokenExpirationDateTime_file);
        return file.readAsString();
      case Constants.key_refreshToken:
        final file = new File(option + Constants.refresh_token_file);
        return file.readAsString();
      default:
    }
  }

  @override
  Future<void> storeDataToStorage(String key, String value) async {
    switch (key) {
      case Constants.key_accessToken:
        final file = new File(option + Constants.access_token_file);
        file.writeAsString(value).then((value) => null);
        break;
      case Constants.key_accessTokenExpirationDateTime:
        final file = new File(option + Constants.accessTokenExpirationDateTime_file);
        file.writeAsString(value).then((value) => null);
        break;
      case Constants.key_refreshToken:
        final file = new File(option + Constants.refresh_token_file);
        file.writeAsString(value).then((value) => null);
        break;
    }
  }

  Future<void> deleteAllDataInStorage() async {
    // await _storage.deleteAll();
  }
}