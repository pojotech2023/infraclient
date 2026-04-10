import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'local_storage.dart';

class SecureLocalStorage implements LocalStorage {
  final FlutterSecureStorage _storage;
  const SecureLocalStorage(this._storage);

  @override
  Future<String> load({required String key, String? boxName}) async {
    return await _storage.read(key: key) ?? '';
  }

  @override
  Future<void> save({
    required String key,
    required value,
    String? boxName,
  }) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete({required String key, String? boxName}) async {
    await _storage.delete(key: key);
  }

  /// ✅ Clears all secure storage entries
  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
