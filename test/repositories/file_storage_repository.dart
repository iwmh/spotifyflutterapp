import 'dart:io';

import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';
import 'package:spotifyflutterapp/util/constants.dart';

class FileStorage implements BaseSecureStorageRepository {
  String option;
  FileStorage([this.option = '']);

  @override
  Future<String> readDataFromStorage(String key) async {
    switch (key) {
      case Constants.key_accessToken:
        final file = File(option + Constants.access_token_file);
        final ret = await file.readAsString();
        return ret == "" ? null : ret;
      case Constants.key_accessTokenExpirationDateTime:
        final file = File(option + Constants.accessTokenExpirationDateTime_file);
        final ret = await file.readAsString();
        return ret == "" ? null : ret;
      case Constants.key_refreshToken:
        final file = File(option + Constants.refresh_token_file);
        final ret = await file.readAsString();
        return ret == "" ? null : ret;
      default:
    }
  }

  @override
  Future<void> storeDataToStorage(String key, String value) async {
    switch (key) {
      case Constants.key_accessToken:
        final file = File(option + Constants.access_token_file);
        await file.writeAsString(value).then((value) => null);
        break;
      case Constants.key_accessTokenExpirationDateTime:
        final file = File(option + Constants.accessTokenExpirationDateTime_file);
        await file.writeAsString(value).then((value) => null);
        break;
      case Constants.key_refreshToken:
        final file = File(option + Constants.refresh_token_file);
        await file.writeAsString(value).then((value) => null);
        break;
    }
  }

  @override
  Future<void> deleteAllDataInStorage() async {
    // await _storage.deleteAll();
  }
}
