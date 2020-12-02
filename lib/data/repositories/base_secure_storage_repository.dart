abstract class BaseSecureStorageRepository {
  // constructor
  BaseSecureStorageRepository();

  // methods
  Future<void> storeDataToStorage(String key, String value) async {}
  Future<String> readDataFromStorage(String key) async {}
  Future<void> deleteAllDataInStorage() async {}
}
