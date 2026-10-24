import 'package:get_it/get_it.dart';
import 'package:hairextensions/core/di/injection.config.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// Registers factories only. Every singleton is lazy, so nothing is built
/// until first use and startup cost stays flat as features grow.
@InjectableInit()
void configureDependencies(String environment) {
  getIt.init(environment: environment);
}
