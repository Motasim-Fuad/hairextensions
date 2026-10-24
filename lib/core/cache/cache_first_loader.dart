import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/cache/api_cache_store.dart';
import 'package:hairextensions/core/cache/cached_payload.dart';
import 'package:hairextensions/core/connectivity/connectivity_service.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';
import 'package:injectable/injectable.dart';

/// Cache-first read for remote-only data: fresh cache wins, otherwise fetch,
/// and fall back to stale cache when offline or the request fails.
@lazySingleton
class CacheFirstLoader {
  CacheFirstLoader(this._cache, this._connectivity);

  static const String _source = 'CacheFirstLoader';

  final ApiCacheStore _cache;
  final ConnectivityService _connectivity;

  Future<Either<Failure, T>> load<T>({
    required String cacheKey,
    required Duration ttl,
    required Future<ApiResponse<T>> Function() fetch,
    required T Function(Object? json) decode,
    required Object? Function(T value) encode,
    bool forceRefresh = false,
  }) async {
    final cached = await _cache.read(cacheKey);
    if (!forceRefresh && cached != null && !cached.isExpired) {
      return _decode(cached, decode);
    }
    if (!await _connectivity.isOnline()) {
      return cached == null ? const Left(NetworkFailure()) : _decode(cached, decode);
    }
    final response = await fetch();
    final data = response.data;
    if (response.isSuccess && data != null) {
      await _cache.write(cacheKey, jsonEncode(encode(data)), ttl);
      return Right(data);
    }
    if (cached != null) {
      AppLogger.warning(_source, 'serving stale cache for $cacheKey');
      return _decode(cached, decode);
    }
    return Left(ApiFailureMapper.toFailure(response));
  }

  Either<Failure, T> _decode<T>(
    CachedPayload cached,
    T Function(Object? json) decode,
  ) {
    try {
      return Right(decode(jsonDecode(cached.payload)));
    } on Object catch (error) {
      AppLogger.error(_source, 'corrupt cache entry', error);
      return const Left(LocalStorageFailure());
    }
  }
}
