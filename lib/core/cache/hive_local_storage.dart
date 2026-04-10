import 'package:hive_flutter/hive_flutter.dart';
import 'local_storage.dart';

class HiveLocalStorage implements LocalStorage {
  @override
  Future<dynamic> load({required String key, String? boxName}) async {
    final box = await Hive.openBox(boxName!);
    try {
      return await box.get(key);
    } finally {
      await box.close();
    }
  }

  @override
  Future<void> save({
    required String key,
    required dynamic value,
    String? boxName,
  }) async {
    final box = await Hive.openBox(boxName!);
    try {
      await box.put(key, value);
    } finally {
      await box.close();
    }
  }

  @override
  Future<void> delete({required String key, String? boxName}) async {
    final box = await Hive.openBox(boxName!);
    try {
      await box.delete(key);
    } finally {
      await box.close();
    }
  }

  /// ✅ Clears and closes all boxes manually.
  @override
  Future<void> clearAll() async {
    try {
      final boxNames = ['auth', 'settings', 'user']; // 🟢 Add all your boxes here
      for (final name in boxNames) {
        if (Hive.isBoxOpen(name)) {
          final box = Hive.box(name);
          await box.clear();
          await box.close();
        } else {
          await Hive.deleteBoxFromDisk(name);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
