import 'package:hairextensions/core/storage/key_value_store.dart';

class InMemoryKeyValueStore implements KeyValueStore {
  InMemoryKeyValueStore([Map<String, Object>? initial]) : _values = {...?initial};

  final Map<String, Object> _values;

  @override
  Future<void> warmUp() async {}

  @override
  String? peekString(String key) => _values[key] as String?;

  @override
  bool? peekBool(String key) => _values[key] as bool?;

  @override
  Future<String?> getString(String key) async => peekString(key);

  @override
  Future<void> setString(String key, String value) async => _values[key] = value;

  @override
  Future<bool?> getBool(String key) async => peekBool(key);

  @override
  Future<void> setBool(String key, {required bool value}) async => _values[key] = value;

  @override
  Future<int?> getInt(String key) async => _values[key] as int?;

  @override
  Future<void> setInt(String key, int value) async => _values[key] = value;

  @override
  Future<void> remove(String key) async => _values.remove(key);

  @override
  Future<void> clear() async => _values.clear();
}
