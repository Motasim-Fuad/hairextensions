import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/bootstrap/app_feature_modules.dart';
import 'package:hairextensions/app/bootstrap/deferred_initializer.dart';
import 'package:hairextensions/app/router/app_router.dart';
import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/network/auth/token_refresher.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source_api.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source_mock.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source_api.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source_mock.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';

import '../../helpers/test_database.dart';

/// Resolving real graphs catches missing registrations and cycles that the
/// generator only reports at build time.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(getIt.reset);

  void useInMemoryDatabase() {
    getIt
      ..allowReassignment = true
      ..registerSingleton<AppDatabase>(TestDatabase.create())
      ..allowReassignment = false;
  }

  test('mock environment wires mock datasources', () async {
    configureDependencies(DiEnv.mock);
    useInMemoryDatabase();

    expect(getIt<AuthRemoteDataSource>(), isA<AuthRemoteDataSourceMock>());
    expect(getIt<BusinessProfileRemoteDataSource>(), isA<BusinessProfileRemoteDataSourceMock>());
    expect(getIt<TokenRefresher>(), isNotNull);
    expect(getIt<BusinessProfileReader>(), isNotNull);
    await getIt<BusinessSetupBloc>().close();
  });

  test('the app shell and deferred startup resolve without cycles', () {
    configureDependencies(DiEnv.mock);
    useInMemoryDatabase();

    expect(getIt<AppRouter>().config, isNotNull);
    expect(getIt<DeferredInitializer>(), isNotNull);
    expect(AppFeatureModules.foreground(), hasLength(AppFeatureModules.features().length + 1));
  });

  test('prod environment swaps in the API datasources with no other change', () {
    configureDependencies(DiEnv.prod);

    expect(getIt<AuthRemoteDataSource>(), isA<AuthRemoteDataSourceApi>());
    expect(getIt<BusinessProfileRemoteDataSource>(), isA<BusinessProfileRemoteDataSourceApi>());
    expect(getIt<TokenRefresher>(), isNotNull);
  });
}
