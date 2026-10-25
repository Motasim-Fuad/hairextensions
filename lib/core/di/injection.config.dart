// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:hairextensions/app/router/guards/auth_guard.dart' as _i2001;
import 'package:hairextensions/core/contracts/account_restorer.dart' as _i2002;
import 'package:hairextensions/core/feature_flags/api_app_config_source.dart'
    as _i2003;
import 'package:hairextensions/core/session/session_refresh.dart' as _i2004;
import 'package:hairextensions/features/auth/data/services/api_account_gateway.dart'
    as _i2005;
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart'
    as _i2006;
import 'package:hairextensions/features/business_setup/data/services/business_account_restorer.dart'
    as _i2007;
import 'package:hairextensions/features/library/data/repositories/remote_library_repository.dart'
    as _i2008;
import 'package:hairextensions/features/quotes/data/repositories/remote_quote_repository.dart'
    as _i2009;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hairextensions/app/background/background_task_scheduler.dart'
    as _i624;
import 'package:hairextensions/app/background/cloud_sync_module.dart' as _i750;
import 'package:hairextensions/app/bootstrap/app_lifecycle_coordinator.dart'
    as _i740;
import 'package:hairextensions/app/bootstrap/deferred_initializer.dart'
    as _i936;
import 'package:hairextensions/app/bootstrap/device_session_starter.dart'
    as _i92;
import 'package:hairextensions/app/router/app_router.dart' as _i808;
import 'package:hairextensions/app/router/guards/app_gate_guard.dart' as _i45;
import 'package:hairextensions/app/router/guards/feature_flag_guard.dart'
    as _i168;
import 'package:hairextensions/app/router/guards/onboarding_guard.dart'
    as _i142;
import 'package:hairextensions/app/router/guards/route_guard_chain.dart'
    as _i912;
import 'package:hairextensions/app/router/guards/setup_guard.dart' as _i513;
import 'package:hairextensions/app/router/guards/subscription_guard.dart'
    as _i582;
import 'package:hairextensions/core/analytics/analytics_service.dart' as _i253;
import 'package:hairextensions/core/analytics/feature_usage_tracker.dart'
    as _i114;
import 'package:hairextensions/core/analytics/firebase_analytics_service.dart'
    as _i96;
import 'package:hairextensions/core/analytics/screen_view_tracker.dart' as _i6;
import 'package:hairextensions/core/cache/api_cache_store.dart' as _i248;
import 'package:hairextensions/core/cache/cache_first_loader.dart' as _i113;
import 'package:hairextensions/core/cache/sqflite_api_cache_store.dart'
    as _i833;
import 'package:hairextensions/core/config/app_config.dart' as _i731;
import 'package:hairextensions/core/connectivity/connectivity_cubit.dart'
    as _i883;
import 'package:hairextensions/core/connectivity/connectivity_plus_service.dart'
    as _i940;
import 'package:hairextensions/core/connectivity/connectivity_service.dart'
    as _i314;
import 'package:hairextensions/core/contracts/business_profile_reader.dart'
    as _i764;
import 'package:hairextensions/core/contracts/catalog_reader.dart' as _i1068;
import 'package:hairextensions/core/contracts/pro_gate.dart' as _i418;
import 'package:hairextensions/core/database/app_database.dart' as _i1066;
import 'package:hairextensions/core/database/database_migrator.dart' as _i305;
import 'package:hairextensions/core/database/database_path_resolver.dart'
    as _i711;
import 'package:hairextensions/core/di/modules/network_module.dart' as _i613;
import 'package:hairextensions/core/di/modules/third_party_module.dart'
    as _i286;
import 'package:hairextensions/core/feature_flags/app_gate_service.dart'
    as _i519;
import 'package:hairextensions/core/feature_flags/beta_targeting.dart' as _i777;
import 'package:hairextensions/core/feature_flags/feature_flag_cache.dart'
    as _i296;
import 'package:hairextensions/core/feature_flags/feature_flag_service.dart'
    as _i690;
import 'package:hairextensions/core/feature_flags/feature_flag_source.dart'
    as _i970;
import 'package:hairextensions/core/feature_flags/feature_module_registry.dart'
    as _i990;
import 'package:hairextensions/core/feature_flags/firebase_remote_config_source.dart'
    as _i979;
import 'package:hairextensions/core/firebase/firebase_bootstrapper.dart'
    as _i1071;
import 'package:hairextensions/core/identity/device_id_provider.dart' as _i1004;
import 'package:hairextensions/core/links/link_launcher.dart' as _i771;
import 'package:hairextensions/core/links/url_link_launcher.dart' as _i221;
import 'package:hairextensions/core/location/geolocator_location_service.dart'
    as _i892;
import 'package:hairextensions/core/location/location_service.dart' as _i39;
import 'package:hairextensions/core/media/image_source_picker.dart' as _i978;
import 'package:hairextensions/core/media/platform_image_source_picker.dart'
    as _i926;
import 'package:hairextensions/core/monitoring/app_bloc_observer.dart' as _i52;
import 'package:hairextensions/core/monitoring/consent/consent_manager.dart'
    as _i942;
import 'package:hairextensions/core/monitoring/crash/crash_reporter.dart'
    as _i160;
import 'package:hairextensions/core/monitoring/crash/firebase_crash_reporter.dart'
    as _i451;
import 'package:hairextensions/core/monitoring/errors/global_error_handler.dart'
    as _i315;
import 'package:hairextensions/core/monitoring/monitoring_initializer.dart'
    as _i19;
import 'package:hairextensions/core/monitoring/performance/firebase_performance_tracer.dart'
    as _i544;
import 'package:hairextensions/core/monitoring/performance/performance_tracer.dart'
    as _i304;
import 'package:hairextensions/core/network/auth/session_expiry_notifier.dart'
    as _i1058;
import 'package:hairextensions/core/network/client/api_client.dart' as _i1039;
import 'package:hairextensions/core/network/client/bare_dio_factory.dart'
    as _i682;
import 'package:hairextensions/core/network/client/dio_factory.dart' as _i87;
import 'package:hairextensions/core/permissions/permission_handler_service.dart'
    as _i945;
import 'package:hairextensions/core/permissions/permission_service.dart'
    as _i214;
import 'package:hairextensions/core/session/app_session.dart' as _i541;
import 'package:hairextensions/core/session/key_value_app_session.dart'
    as _i911;
import 'package:hairextensions/core/shared_entities/product.dart' as _i241;
import 'package:hairextensions/core/storage/key_value_store.dart' as _i30;
import 'package:hairextensions/core/storage/secure_storage_token_store.dart'
    as _i665;
import 'package:hairextensions/core/storage/secure_token_store.dart' as _i580;
import 'package:hairextensions/core/storage/sqflite_key_value_store.dart'
    as _i592;
import 'package:hairextensions/core/subscription/cached_subscription_service.dart'
    as _i944;
import 'package:hairextensions/core/subscription/subscription_service.dart'
    as _i79;
import 'package:hairextensions/core/sync/sqflite_sync_queue.dart' as _i485;
import 'package:hairextensions/core/sync/sync_engine.dart' as _i629;
import 'package:hairextensions/core/sync/sync_handler_registry.dart' as _i82;
import 'package:hairextensions/core/sync/sync_queue.dart' as _i1069;
import 'package:hairextensions/core/utils/clock.dart' as _i264;
import 'package:hairextensions/core/utils/id_generator.dart' as _i635;
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart'
    as _i548;
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source_api.dart'
    as _i330;
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source_mock.dart'
    as _i914;
import 'package:hairextensions/features/auth/data/repositories/auth_repository_impl.dart'
    as _i865;
import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart'
    as _i346;
import 'package:hairextensions/features/business_setup/business_setup_module.dart'
    as _i496;
import 'package:hairextensions/features/business_setup/data/datasources/local/business_profile_local_data_source.dart'
    as _i689;
import 'package:hairextensions/features/business_setup/data/datasources/local/business_profile_local_data_source_impl.dart'
    as _i1003;
import 'package:hairextensions/features/business_setup/data/datasources/local/logo_file_store.dart'
    as _i83;
import 'package:hairextensions/features/business_setup/data/datasources/local/logo_file_store_impl.dart'
    as _i1055;
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart'
    as _i974;
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source_api.dart'
    as _i303;
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source_mock.dart'
    as _i336;
import 'package:hairextensions/features/business_setup/data/repositories/business_profile_repository_impl.dart'
    as _i278;
import 'package:hairextensions/features/business_setup/data/services/business_profile_reader_impl.dart'
    as _i143;
import 'package:hairextensions/features/business_setup/data/sync/business_profile_sync_handler.dart'
    as _i145;
import 'package:hairextensions/features/business_setup/domain/repositories/business_profile_repository.dart'
    as _i100;
import 'package:hairextensions/features/business_setup/domain/usecases/get_business_profile.dart'
    as _i866;
import 'package:hairextensions/features/business_setup/domain/usecases/pick_business_logo.dart'
    as _i760;
import 'package:hairextensions/features/business_setup/domain/usecases/save_business_profile.dart'
    as _i179;
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart'
    as _i25;
import 'package:hairextensions/features/business_setup/presentation/bloc/setup_summary/setup_summary_cubit.dart'
    as _i827;
import 'package:hairextensions/features/library/data/repositories/demo_library_repository.dart'
    as _i95;
import 'package:hairextensions/features/library/data/services/catalog_reader_impl.dart'
    as _i176;
import 'package:hairextensions/features/library/domain/repositories/library_repository.dart'
    as _i156;
import 'package:hairextensions/features/library/presentation/bloc/library/library_cubit.dart'
    as _i972;
import 'package:hairextensions/features/library/presentation/bloc/product_form/product_form_cubit.dart'
    as _i498;
import 'package:hairextensions/features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i352;
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_cubit.dart'
    as _i157;
import 'package:hairextensions/features/paywall/presentation/services/pro_gate_impl.dart'
    as _i255;
import 'package:hairextensions/features/quotes/data/repositories/demo_quote_repository.dart'
    as _i379;
import 'package:hairextensions/features/quotes/data/services/pdf_quote_document_sharer.dart'
    as _i154;
import 'package:hairextensions/features/quotes/domain/entities/line_category.dart'
    as _i864;
import 'package:hairextensions/features/quotes/domain/entities/quote.dart'
    as _i954;
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart'
    as _i561;
import 'package:hairextensions/features/quotes/domain/services/quote_document_sharer.dart'
    as _i562;
import 'package:hairextensions/features/quotes/presentation/bloc/add_hair/add_hair_cubit.dart'
    as _i106;
import 'package:hairextensions/features/quotes/presentation/bloc/add_item/add_item_cubit.dart'
    as _i5;
import 'package:hairextensions/features/quotes/presentation/bloc/add_service/add_service_cubit.dart'
    as _i915;
import 'package:hairextensions/features/quotes/presentation/bloc/builder/quote_builder_cubit.dart'
    as _i796;
import 'package:hairextensions/features/quotes/presentation/bloc/detail/quote_detail_cubit.dart'
    as _i1051;
import 'package:hairextensions/features/quotes/presentation/bloc/history/quote_history_cubit.dart'
    as _i197;
import 'package:hairextensions/features/quotes/presentation/bloc/home/home_cubit.dart'
    as _i721;
import 'package:hairextensions/features/quotes/presentation/bloc/preview/quote_preview_cubit.dart'
    as _i916;
import 'package:hairextensions/features/quotes/presentation/bloc/review/quote_review_cubit.dart'
    as _i1047;
import 'package:hairextensions/features/settings/presentation/bloc/settings_cubit.dart'
    as _i449;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sqflite/sqflite.dart' as _i779;
import 'package:uuid/uuid.dart' as _i706;

const String _mock = 'mock';
const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyModule = _$ThirdPartyModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i624.BackgroundTaskScheduler>(
      () => _i624.BackgroundTaskScheduler(),
    );
    gh.lazySingleton<_i305.DatabaseMigrator>(() => _i305.DatabaseMigrator());
    gh.lazySingleton<_i731.AppConfig>(() => thirdPartyModule.appConfig);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => thirdPartyModule.secureStorage,
    );
    gh.lazySingleton<_i895.Connectivity>(() => thirdPartyModule.connectivity);
    gh.lazySingleton<_i779.DatabaseFactory>(
      () => thirdPartyModule.databaseFactory,
    );
    gh.lazySingleton<_i706.Uuid>(() => thirdPartyModule.uuid);
    gh.lazySingleton<_i1071.FirebaseBootstrapper>(
      () => _i1071.FirebaseBootstrapper(),
    );
    gh.lazySingleton<_i1058.SessionExpiryNotifier>(
      () => _i1058.SessionExpiryNotifier(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i82.SyncHandlerRegistry>(
      () => _i82.SyncHandlerRegistry(),
    );
    gh.lazySingleton<_i264.Clock>(() => _i264.Clock());
    gh.lazySingleton<_i974.BusinessProfileRemoteDataSource>(
      () => _i336.BusinessProfileRemoteDataSourceMock(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i214.PermissionService>(
      () => _i945.PermissionHandlerService(),
    );
    gh.lazySingleton<_i978.ImageSourcePicker>(
      () => _i926.PlatformImageSourcePicker(),
    );
    gh.lazySingleton<_i635.IdGenerator>(
      () => _i635.IdGenerator(gh<_i706.Uuid>()),
    );
    gh.lazySingleton<_i771.LinkLauncher>(() => _i221.UrlLinkLauncher());
    gh.lazySingleton<_i562.QuoteDocumentSharer>(
      () => _i154.PdfQuoteDocumentSharer(),
    );
    gh.lazySingleton<_i711.DatabasePathResolver>(
      () => _i711.DatabasePathResolver(gh<_i779.DatabaseFactory>()),
    );
    gh.lazySingleton<_i580.SecureTokenStore>(
      () => _i665.SecureStorageTokenStore(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i83.LogoFileStore>(
      () => _i1055.LogoFileStoreImpl(gh<_i264.Clock>()),
    );
    gh.lazySingleton<_i314.ConnectivityService>(
      () => _i940.ConnectivityPlusService(gh<_i895.Connectivity>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i39.LocationService>(
      () => _i892.GeolocatorLocationService(gh<_i214.PermissionService>()),
    );
    gh.lazySingleton<_i883.ConnectivityCubit>(
      () => _i883.ConnectivityCubit(gh<_i314.ConnectivityService>()),
    );
    gh.lazySingleton<_i561.QuoteRepository>(
      () => _i379.DemoQuoteRepository(gh<_i264.Clock>()),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i156.LibraryRepository>(
      () => _i95.DemoLibraryRepository(gh<_i264.Clock>()),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i253.AnalyticsService>(
      () => _i96.FirebaseAnalyticsService(gh<_i1071.FirebaseBootstrapper>()),
    );
    gh.lazySingleton<_i304.PerformanceTracer>(
      () => _i544.FirebasePerformanceTracer(gh<_i1071.FirebaseBootstrapper>()),
    );
    gh.lazySingleton<_i682.BareDioFactory>(
      () => _i682.BareDioFactory(gh<_i731.AppConfig>()),
    );
    gh.lazySingleton<_i979.FirebaseRemoteConfigSource>(
      () => _i979.FirebaseRemoteConfigSource(gh<_i1071.FirebaseBootstrapper>()),
    );
    gh.lazySingleton<_i160.CrashReporter>(
      () => _i451.FirebaseCrashReporter(gh<_i1071.FirebaseBootstrapper>()),
    );
    gh.factory<_i197.QuoteHistoryCubit>(
      () => _i197.QuoteHistoryCubit(
        gh<_i561.QuoteRepository>(),
        gh<_i264.Clock>(),
      ),
    );
    gh.lazySingleton<_i1066.AppDatabase>(
      () => _i1066.AppDatabase(
        gh<_i779.DatabaseFactory>(),
        gh<_i711.DatabasePathResolver>(),
        gh<_i305.DatabaseMigrator>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i1068.CatalogReader>(
      () => _i176.CatalogReaderImpl(gh<_i156.LibraryRepository>()),
    );
    gh.lazySingleton<_i548.AuthRemoteDataSource>(
      () => _i914.AuthRemoteDataSourceMock(gh<_i635.IdGenerator>()),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i52.AppBlocObserver>(
      () => _i52.AppBlocObserver(gh<_i160.CrashReporter>()),
    );
    gh.lazySingleton<_i315.GlobalErrorHandler>(
      () => _i315.GlobalErrorHandler(gh<_i160.CrashReporter>()),
    );
    gh.factory<_i1051.QuoteDetailCubit>(
      () => _i1051.QuoteDetailCubit(gh<_i561.QuoteRepository>()),
    );
    gh.factory<_i972.LibraryCubit>(
      () => _i972.LibraryCubit(gh<_i156.LibraryRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.bareDio(gh<_i682.BareDioFactory>()),
      instanceName: 'bareDio',
    );
    gh.factoryParam<_i498.ProductFormCubit, _i241.Product?, dynamic>(
      (existing, _) => _i498.ProductFormCubit(
        gh<_i156.LibraryRepository>(),
        gh<_i264.Clock>(),
        gh<_i635.IdGenerator>(),
        existing,
      ),
    );
    gh.factory<_i106.AddHairCubit>(
      () => _i106.AddHairCubit(
        gh<_i1068.CatalogReader>(),
        gh<_i635.IdGenerator>(),
      ),
    );
    gh.factory<_i915.AddServiceCubit>(
      () => _i915.AddServiceCubit(
        gh<_i1068.CatalogReader>(),
        gh<_i635.IdGenerator>(),
      ),
    );
    gh.lazySingleton<_i114.FeatureUsageTracker>(
      () => _i114.FeatureUsageTracker(gh<_i253.AnalyticsService>()),
    );
    gh.lazySingleton<_i6.ScreenViewTracker>(
      () => _i6.ScreenViewTracker(gh<_i253.AnalyticsService>()),
    );
    gh.lazySingleton<_i248.ApiCacheStore>(
      () => _i833.SqfliteApiCacheStore(
        gh<_i1066.AppDatabase>(),
        gh<_i264.Clock>(),
      ),
    );
    gh.lazySingleton<_i689.BusinessProfileLocalDataSource>(
      () => _i1003.BusinessProfileLocalDataSourceImpl(gh<_i1066.AppDatabase>()),
      dispose: (i) => i.dispose(),
    );
    gh.factoryParam<_i1047.QuoteReviewCubit, _i954.Quote?, dynamic>(
      (quote, _) => _i1047.QuoteReviewCubit(gh<_i561.QuoteRepository>(), quote),
    );
    gh.lazySingleton<_i1069.SyncQueue>(
      () => _i485.SqfliteSyncQueue(gh<_i1066.AppDatabase>(), gh<_i264.Clock>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i30.KeyValueStore>(
      () => _i592.SqfliteKeyValueStore(
        gh<_i1066.AppDatabase>(),
        gh<_i264.Clock>(),
      ),
    );
    gh.lazySingleton<_i764.BusinessProfileReader>(
      () => _i143.BusinessProfileReaderImpl(
        gh<_i689.BusinessProfileLocalDataSource>(),
      ),
    );
    gh.factory<_i796.QuoteBuilderCubit>(
      () => _i796.QuoteBuilderCubit(
        gh<_i561.QuoteRepository>(),
        gh<_i764.BusinessProfileReader>(),
        gh<_i635.IdGenerator>(),
        gh<_i264.Clock>(),
      ),
    );
    gh.lazySingleton<_i79.SubscriptionService>(
      () => _i944.CachedSubscriptionService(gh<_i30.KeyValueStore>()),
    );
    gh.factoryParam<_i5.AddItemCubit, _i864.LineCategory?, dynamic>(
      (category, _) => _i5.AddItemCubit(
        gh<_i1068.CatalogReader>(),
        gh<_i635.IdGenerator>(),
        category,
      ),
    );
    gh.lazySingleton<_i1004.DeviceIdProvider>(
      () => _i1004.DeviceIdProvider(
        gh<_i30.KeyValueStore>(),
        gh<_i635.IdGenerator>(),
      ),
    );
    gh.lazySingleton<_i629.SyncEngine>(
      () => _i629.SyncEngine(
        gh<_i1069.SyncQueue>(),
        gh<_i82.SyncHandlerRegistry>(),
        gh<_i314.ConnectivityService>(),
        gh<_i264.Clock>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i548.AuthRemoteDataSource>(
      () =>
          _i330.AuthRemoteDataSourceApi(gh<_i361.Dio>(instanceName: 'bareDio')),
      registerFor: {_dev, _prod},
    );
    gh.lazySingleton<_i113.CacheFirstLoader>(
      () => _i113.CacheFirstLoader(
        gh<_i248.ApiCacheStore>(),
        gh<_i314.ConnectivityService>(),
      ),
    );
    gh.lazySingleton<_i296.FeatureFlagCache>(
      () => _i296.FeatureFlagCache(gh<_i30.KeyValueStore>()),
    );
    gh.lazySingleton<_i942.ConsentManager>(
      () => _i942.ConsentManager(gh<_i30.KeyValueStore>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i541.AppSession>(
      () => _i911.KeyValueAppSession(gh<_i30.KeyValueStore>()),
    );
    gh.factory<_i721.HomeCubit>(
      () => _i721.HomeCubit(
        gh<_i561.QuoteRepository>(),
        gh<_i764.BusinessProfileReader>(),
        gh<_i264.Clock>(),
      ),
    );
    gh.factory<_i157.PaywallCubit>(
      () => _i157.PaywallCubit(
        gh<_i79.SubscriptionService>(),
        gh<_i731.AppConfig>(),
        gh<_i771.LinkLauncher>(),
      ),
    );
    gh.factory<_i916.QuotePreviewCubit>(
      () => _i916.QuotePreviewCubit(
        gh<_i561.QuoteRepository>(),
        gh<_i764.BusinessProfileReader>(),
        gh<_i562.QuoteDocumentSharer>(),
      ),
    );
    gh.lazySingleton<_i750.CloudSyncModule>(
      () => _i750.CloudSyncModule(
        gh<_i629.SyncEngine>(),
        gh<_i624.BackgroundTaskScheduler>(),
      ),
    );
    gh.lazySingleton<_i777.BetaTargeting>(
      () => _i777.BetaTargeting(
        gh<_i30.KeyValueStore>(),
        gh<_i253.AnalyticsService>(),
      ),
    );
    gh.factory<_i352.OnboardingCubit>(
      () => _i352.OnboardingCubit(gh<_i541.AppSession>()),
    );
    gh.lazySingleton<_i142.OnboardingGuard>(
      () => _i142.OnboardingGuard(gh<_i541.AppSession>()),
    );
    gh.lazySingleton<_i513.SetupGuard>(
      () => _i513.SetupGuard(gh<_i541.AppSession>()),
    );
    gh.lazySingleton<_i346.AuthRepository>(
      () => _i865.AuthRepositoryImpl(
        gh<_i548.AuthRemoteDataSource>(),
        gh<_i580.SecureTokenStore>(),
        gh<_i541.AppSession>(),
        gh<_i2002.AccountRestorer>(),
        gh<_i2004.SessionRefresh>(),
      ),
    );
    gh.lazySingleton<_i100.BusinessProfileRepository>(
      () => _i278.BusinessProfileRepositoryImpl(
        gh<_i689.BusinessProfileLocalDataSource>(),
        gh<_i83.LogoFileStore>(),
        gh<_i978.ImageSourcePicker>(),
        gh<_i1069.SyncQueue>(),
        gh<_i541.AppSession>(),
        gh<_i264.Clock>(),
        gh<_i974.BusinessProfileRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i866.GetBusinessProfile>(
      () => _i866.GetBusinessProfile(gh<_i100.BusinessProfileRepository>()),
    );
    gh.lazySingleton<_i760.PickBusinessLogo>(
      () => _i760.PickBusinessLogo(gh<_i100.BusinessProfileRepository>()),
    );
    gh.lazySingleton<_i179.SaveBusinessProfile>(
      () => _i179.SaveBusinessProfile(gh<_i100.BusinessProfileRepository>()),
    );
    gh.factory<_i827.SetupSummaryCubit>(
      () => _i827.SetupSummaryCubit(gh<_i866.GetBusinessProfile>()),
    );
    gh.lazySingleton<_i87.DioFactory>(
      () => _i87.DioFactory(
        gh<_i731.AppConfig>(),
        gh<_i580.SecureTokenStore>(),
        gh<_i1058.SessionExpiryNotifier>(),
        gh<_i304.PerformanceTracer>(),
      ),
    );
    gh.lazySingleton<_i690.FeatureFlagService>(
      () => _i690.FeatureFlagService(
        gh<_i970.FeatureFlagSource>(),
        gh<_i296.FeatureFlagCache>(),
        gh<_i777.BetaTargeting>(),
      ),
    );
    gh.lazySingleton<_i92.DeviceSessionStarter>(
      () => _i92.DeviceSessionStarter(
        gh<_i346.AuthRepository>(),
        gh<_i1058.SessionExpiryNotifier>(),
        gh<_i541.AppSession>(),
        gh<_i580.SecureTokenStore>(),
        gh<_i2002.AccountRestorer>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i25.BusinessSetupBloc>(
      () => _i25.BusinessSetupBloc(
        gh<_i866.GetBusinessProfile>(),
        gh<_i179.SaveBusinessProfile>(),
        gh<_i760.PickBusinessLogo>(),
        gh<_i214.PermissionService>(),
      ),
    );
    gh.lazySingleton<_i168.FeatureFlagGuard>(
      () => _i168.FeatureFlagGuard(gh<_i690.FeatureFlagService>()),
    );
    gh.lazySingleton<_i519.AppGateService>(
      () => _i519.AppGateService(gh<_i690.FeatureFlagService>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i990.FeatureModuleRegistry>(
      () => _i990.FeatureModuleRegistry(gh<_i690.FeatureFlagService>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i19.MonitoringInitializer>(
      () => _i19.MonitoringInitializer(
        gh<_i1071.FirebaseBootstrapper>(),
        gh<_i942.ConsentManager>(),
        gh<_i160.CrashReporter>(),
        gh<_i253.AnalyticsService>(),
        gh<_i304.PerformanceTracer>(),
        gh<_i690.FeatureFlagService>(),
        gh<_i519.AppGateService>(),
        gh<_i777.BetaTargeting>(),
        gh<_i990.FeatureModuleRegistry>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio(gh<_i87.DioFactory>()));
    gh.lazySingleton<_i582.SubscriptionGuard>(
      () => _i582.SubscriptionGuard(
        gh<_i79.SubscriptionService>(),
        gh<_i690.FeatureFlagService>(),
      ),
    );
    gh.lazySingleton<_i418.ProGate>(
      () => _i255.ProGateImpl(
        gh<_i79.SubscriptionService>(),
        gh<_i690.FeatureFlagService>(),
      ),
    );
    gh.lazySingleton<_i740.AppLifecycleCoordinator>(
      () => _i740.AppLifecycleCoordinator(gh<_i19.MonitoringInitializer>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i1039.ApiClient>(() => _i1039.ApiClient(gh<_i361.Dio>()));
    gh.factory<_i449.SettingsCubit>(
      () => _i449.SettingsCubit(
        gh<_i764.BusinessProfileReader>(),
        gh<_i1068.CatalogReader>(),
        gh<_i79.SubscriptionService>(),
        gh<_i731.AppConfig>(),
        gh<_i771.LinkLauncher>(),
        gh<_i346.AuthRepository>(),
        gh<_i519.AppGateService>(),
      ),
    );
    gh.lazySingleton<_i936.DeferredInitializer>(
      () => _i936.DeferredInitializer(
        gh<_i990.FeatureModuleRegistry>(),
        gh<_i19.MonitoringInitializer>(),
        gh<_i883.ConnectivityCubit>(),
        gh<_i92.DeviceSessionStarter>(),
        gh<_i740.AppLifecycleCoordinator>(),
      ),
    );
    gh.lazySingleton<_i45.AppGateGuard>(
      () => _i45.AppGateGuard(gh<_i519.AppGateService>()),
    );
    gh.lazySingleton<_i974.BusinessProfileRemoteDataSource>(
      () => _i303.BusinessProfileRemoteDataSourceApi(gh<_i1039.ApiClient>()),
      registerFor: {_dev, _prod},
    );
    gh.lazySingleton<_i145.BusinessProfileSyncHandler>(
      () => _i145.BusinessProfileSyncHandler(
        gh<_i974.BusinessProfileRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i912.RouteGuardChain>(
      () => _i912.RouteGuardChain(
        gh<_i45.AppGateGuard>(),
        gh<_i142.OnboardingGuard>(),
        gh<_i2001.AuthGuard>(),
        gh<_i513.SetupGuard>(),
        gh<_i168.FeatureFlagGuard>(),
        gh<_i582.SubscriptionGuard>(),
      ),
    );
    gh.lazySingleton<_i808.AppRouter>(
      () => _i808.AppRouter(
        gh<_i912.RouteGuardChain>(),
        gh<_i519.AppGateService>(),
        gh<_i690.FeatureFlagService>(),
        gh<_i79.SubscriptionService>(),
        gh<_i6.ScreenViewTracker>(),
        gh<_i771.LinkLauncher>(),
        gh<_i2004.SessionRefresh>(),
      ),
    );
    gh.lazySingleton<_i496.BusinessSetupModule>(
      () => _i496.BusinessSetupModule(
        gh<_i82.SyncHandlerRegistry>(),
        gh<_i145.BusinessProfileSyncHandler>(),
      ),
    );
    gh.lazySingleton<_i2004.SessionRefresh>(() => _i2004.SessionRefresh());
    gh.lazySingleton<_i2001.AuthGuard>(
      () => _i2001.AuthGuard(gh<_i541.AppSession>()),
    );
    gh.lazySingleton<_i2002.AccountRestorer>(
      () => _i2007.BusinessAccountRestorer(
        gh<_i974.BusinessProfileRemoteDataSource>(),
        gh<_i689.BusinessProfileLocalDataSource>(),
        gh<_i541.AppSession>(),
        gh<_i1069.SyncQueue>(),
      ),
    );
    gh.lazySingleton<_i2006.AccountGateway>(
      () => _i2005.ApiAccountGateway(gh<_i346.AuthRepository>()),
    );
    gh.lazySingleton<_i970.FeatureFlagSource>(
      () => _i2003.ApiAppConfigSource(
        gh<_i979.FirebaseRemoteConfigSource>(),
        gh<_i1039.ApiClient>(),
        gh<_i731.AppConfig>(),
      ),
    );
    gh.lazySingleton<_i156.LibraryRepository>(
      () => _i2008.RemoteLibraryRepository(
        gh<_i1039.ApiClient>(),
        gh<_i580.SecureTokenStore>(),
      ),
      registerFor: {_dev, _prod},
    );
    gh.lazySingleton<_i561.QuoteRepository>(
      () => _i2009.RemoteQuoteRepository(
        gh<_i1039.ApiClient>(),
        gh<_i580.SecureTokenStore>(),
        gh<_i764.BusinessProfileReader>(),
      ),
      registerFor: {_dev, _prod},
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i286.ThirdPartyModule {}

class _$NetworkModule extends _i613.NetworkModule {}
