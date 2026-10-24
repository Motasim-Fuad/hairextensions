import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Disk cache for remote images with bounded size and age.
class AppImageCacheManager extends CacheManager with ImageCacheManager {
  factory AppImageCacheManager() => _instance;

  AppImageCacheManager._() : super(Config(cacheKey, stalePeriod: stalePeriod, maxNrOfCacheObjects: maxObjects));

  static const String cacheKey = 'appImageCache';
  static const Duration stalePeriod = Duration(days: 30);
  static const int maxObjects = 200;
  static final AppImageCacheManager _instance = AppImageCacheManager._();
}
