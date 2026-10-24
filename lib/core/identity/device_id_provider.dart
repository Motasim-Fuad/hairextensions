import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/storage/key_value_store.dart';
import 'package:hairextensions/core/utils/id_generator.dart';
import 'package:injectable/injectable.dart';

/// Stable per-install id used for the silent device session, crash and
/// analytics user ids, and Remote Config targeting.
@lazySingleton
class DeviceIdProvider {
  DeviceIdProvider(this._store, this._ids);

  final KeyValueStore _store;
  final IdGenerator _ids;
  Future<String>? _obtaining;

  String? get cached => _store.peekString(StorageKeys.deviceId);

  Future<String> obtain() => _obtaining ??= _obtain();

  Future<String> _obtain() async {
    final existing = await _store.getString(StorageKeys.deviceId);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final created = _ids.next();
    await _store.setString(StorageKeys.deviceId, created);
    return created;
  }
}
