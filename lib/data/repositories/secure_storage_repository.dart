import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotifyflutterapp/data/repositories/base_secure_storage_repository.dart';

class SecureStorage implements BaseSecureStorage {

  // storage instance
  FlutterSecureStorage _storage;

  SecureStorage(){
    _storage = new FlutterSecureStorage();
  }

  @override
  Future<String> readDataFromStorage(String key) async{
    return await _storage.read(key: key);
  }

  @override
  Future<void> storeDateToStorage(String key, String value) async{
    await _storage.write(key: key, value: value);
  }
  
}