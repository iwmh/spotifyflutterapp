import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';

class SecureStorageRepository implements BaseSecureStorageRepository {
  // storage instance
  FlutterSecureStorage _storage;

  SecureStorageRepository(this._storage);

  @override
  Future<String> readDataFromStorage(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> storeDataToStorage(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> deleteAllDataInStorage() async {
    await _storage.deleteAll();
  }
}
