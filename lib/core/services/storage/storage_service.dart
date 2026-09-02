abstract class StorageService {
  Future<void> init();
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> clearAll();
}
