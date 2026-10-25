import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/app/bootstrap/app_feature_modules.dart';
import 'package:hairextensions/app/bootstrap/deferred_initializer.dart';
import 'package:hairextensions/app/router/app_router.dart';
import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/database/app_database.dart';
import 'package:hairextensions/core/di/di_env.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/contracts/account_restorer.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source_api.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source_mock.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source_api.dart';
import 'package:hairextensions/features/business_setup/data/datasources/remote/business_profile_remote_data_source_mock.dart';
import 'package:hairextensions/features/auth/domain/services/account_gateway.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/business_setup/business_setup_bloc.dart';
import 'package:hairextensions/features/library/data/repositories/demo_library_repository.dart';
import 'package:hairextensions/features/library/data/repositories/remote_library_repository.dart';
import 'package:hairextensions/features/library/domain/repositories/library_repository.dart';
import 'package:hairextensions/features/quotes/data/repositories/demo_quote_repository.dart';
import 'package:hairextensions/features/quotes/data/repositories/remote_quote_repository.dart';
import 'package:hairextensions/features/quotes/domain/repositories/quote_repository.dart';

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
    expect(getIt<AccountGateway>(), isNotNull);
    expect(getIt<AccountRestorer>(), isNotNull);
    expect(getIt<LibraryRepository>(), isA<DemoLibraryRepository>());
    expect(getIt<QuoteRepository>(), isA<DemoQuoteRepository>());
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
  });

  test('prod environment serves the library and quotes from the API', () {
    configureDependencies(DiEnv.prod);
    useInMemoryDatabase();

    expect(getIt<LibraryRepository>(), isA<RemoteLibraryRepository>());
    expect(getIt<QuoteRepository>(), isA<RemoteQuoteRepository>());
    expect(getIt<AccountGateway>(), isNotNull);
  });
}
