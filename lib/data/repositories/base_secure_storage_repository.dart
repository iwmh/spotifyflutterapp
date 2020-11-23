abstract class BaseSecureStorage {
  // constructor
  BaseSecureStorage();

  // methods
  Future<void> storeDataToStorage(String key, String value) async {}
  Future<String> readDataFromStorage(String key) async {}
  Future<void> deleteAllDataInStorage() async {}
}
