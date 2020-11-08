abstract class BaseSecureStorage {

  // constructor
  BaseSecureStorage();

  // methods
  Future<void> storeDateToStorage(String key, String value) async{}
  Future<String> readDataFromStorage(String key) async{}

}