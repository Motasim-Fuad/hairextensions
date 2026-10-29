import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hairextensions/core/constants/storage_keys.dart';
import 'package:hairextensions/core/shared_entities/auth_tokens.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SecureTokenStore)
class SecureStorageTokenStore implements SecureTokenStore {
  SecureStorageTokenStore(this._storage);

  final FlutterSecureStorage _storage;
  AuthTokens? _cache;
  bool _loaded = false;

  @override
  String? get cachedAccessToken => _cache?.accessToken;

  @override
  Future<AuthTokens?> read() async {
    if (_loaded) {
      return _cache;
    }
    final access = await _storage.read(key: StorageKeys.accessToken);
    final expiresAt = await _storage.read(key: StorageKeys.tokenExpiresAt);
    _loaded = true;
    if (access == null) {
      return _cache = null;
    }
    return _cache = AuthTokens(
      accessToken: access,
      refreshToken: await _storage.read(key: StorageKeys.refreshToken),
      expiresAt: expiresAt == null ? null : DateTime.tryParse(expiresAt),
    );
  }

  @override
  Future<void> save(AuthTokens tokens) async {
    _cache = tokens;
    _loaded = true;
    await _storage.write(
      key: StorageKeys.accessToken,
      value: tokens.accessToken,
    );
    await _storage.write(
      key: StorageKeys.refreshToken,
      value: tokens.refreshToken,
    );
    final expiresAt = tokens.expiresAt;
    if (expiresAt == null) {
      await _storage.delete(key: StorageKeys.tokenExpiresAt);
    } else {
      await _storage.write(
        key: StorageKeys.tokenExpiresAt,
        value: expiresAt.toIso8601String(),
      );
    }
  }

  @override
  Future<void> clear() async {
    _cache = null;
    _loaded = true;
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.tokenExpiresAt);
  }
}
