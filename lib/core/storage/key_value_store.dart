/// Small settings store. [warmUp] loads every entry into memory once so the
/// peek methods can answer synchronously, for example in router redirects.
abstract interface class KeyValueStore {
  Future<void> warmUp();

  String? peekString(String key);

  bool? peekBool(String key);

  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<bool?> getBool(String key);

  Future<void> setBool(String key, {required bool value});

  Future<int?> getInt(String key);

  Future<void> setInt(String key, int value);

  Future<void> remove(String key);

  Future<void> clear();
}
