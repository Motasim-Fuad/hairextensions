import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:hairextensions/core/constants/network_constants.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/client/api_client.dart';
import 'package:hairextensions/core/network/mappers/api_failure_mapper.dart';
import 'package:hairextensions/core/shared_entities/material_item.dart';
import 'package:hairextensions/core/shared_entities/product.dart';
import 'package:hairextensions/core/shared_entities/service_template.dart';
import 'package:hairextensions/core/storage/secure_token_store.dart';
import 'package:hairextensions/features/library/data/mappers/library_item_mapper.dart';
import 'package:hairextensions/features/library/data/models/library_item_dto.dart';
import 'package:hairextensions/features/library/domain/repositories/library_repository.dart';
import 'package:injectable/injectable.dart';

/// The stylist's library, served by `/v1/library`. The server is the source of
/// truth; the list is cached in memory and re-read after every change, so
/// every screen watching it updates together.
@LazySingleton(as: LibraryRepository, env: DiEnv.remote)
class RemoteLibraryRepository implements LibraryRepository {
  RemoteLibraryRepository(this._client, this._tokens);

  static const String _source = 'LibraryRepository';
  static const String _path = '${NetworkConstants.apiPrefix}/library';
  static const int _pageSize = 100;

  final ApiClient _client;
  final SecureTokenStore _tokens;
  final StreamController<void> _changes = StreamController<void>.broadcast();
  List<LibraryItemDto>? _items;
  String? _loadedForToken;
  Future<void>? _loading;

  @override
  Stream<List<Product>> watchProducts() => _watch((items) => [
    for (final item in items)
      if (item.kind == LibraryItemDto.hair) LibraryItemMapper.toProduct(item),
  ]);

  @override
  Stream<List<MaterialItem>> watchMaterials() => _watch((items) => [
    for (final item in items)
      if (item.kind == LibraryItemDto.material) LibraryItemMapper.toMaterial(item),
  ]);

  @override
  Stream<List<ServiceTemplate>> watchServices() => _watch((items) => [
    for (final item in items)
      if (item.kind == LibraryItemDto.labour || item.kind == LibraryItemDto.service) LibraryItemMapper.toService(item),
  ]);

  @override
  Future<Either<Failure, Product>> saveProduct(Product product) async {
    final id = int.tryParse(product.id);
    final body = LibraryItemMapper.productToApi(product);
    final ApiResponse<LibraryItemDto> response = id != null && _exists(id)
        ? await _client.patch('$_path/$id', body: body, parser: LibraryItemDto.fromJson)
        : await _client.post(_path, body: body, parser: LibraryItemDto.fromJson);
    final saved = response.data;
    if (!response.isSuccess || saved == null) {
      return Left(ApiFailureMapper.toFailure(response));
    }
    _items = [saved, ...?_items?.where((item) => item.id != saved.id)];
    _changes.add(null);
    return Right(LibraryItemMapper.toProduct(saved));
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    final numeric = int.tryParse(id);
    if (numeric == null) {
      return const Right(unit);
    }
    final response = await _client.delete<void>('$_path/$numeric', parser: (_) {});
    if (!response.isSuccess && !response.isNotFound) {
      return Left(ApiFailureMapper.toFailure(response));
    }
    _items = _items?.where((item) => item.id != numeric).toList();
    _changes.add(null);
    return const Right(unit);
  }

  bool _exists(int id) => _items?.any((item) => item.id == id) ?? false;

  Stream<List<T>> _watch<T>(List<T> Function(List<LibraryItemDto> items) select) async* {
    _resetForNewAccount();
    if (_items == null) {
      unawaited(_refresh());
    }
    yield select(_items ?? const []);
    yield* _changes.stream.map((_) => select(_items ?? const []));
  }

  /// A different bearer token means a different account: drop the old list.
  void _resetForNewAccount() {
    final token = _tokens.cachedAccessToken;
    if (token != _loadedForToken) {
      _loadedForToken = token;
      _items = null;
      _loading = null;
    }
  }

  Future<void> _refresh() => _loading ??= _load().whenComplete(() => _loading = null);

  Future<void> _load() async {
    final loaded = <LibraryItemDto>[];
    var offset = 0;
    while (true) {
      final response = await _client.get<_Page>(
        _path,
        query: {'limit': _pageSize, 'offset': offset},
        parser: _Page.fromJson,
      );
      final page = response.data;
      if (!response.isSuccess || page == null) {
        AppLogger.warning(_source, 'load failed ${response.statusCode}');
        return;
      }
      loaded.addAll(page.items);
      offset += page.items.length;
      if (page.items.isEmpty || offset >= page.total) {
        break;
      }
    }
    _items = loaded;
    _changes.add(null);
  }
}

class _Page {
  const _Page({required this.items, required this.total});

  factory _Page.fromJson(Object? json) {
    final map = json! as Map<String, dynamic>;
    return _Page(
      items: [for (final item in map['items'] as List<dynamic>) LibraryItemDto.fromJson(item)],
      total: (map['total'] as num).toInt(),
    );
  }

  final List<LibraryItemDto> items;
  final int total;
}
