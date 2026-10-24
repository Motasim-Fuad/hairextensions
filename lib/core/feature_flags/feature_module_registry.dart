import 'dart:async';

import 'package:hairextensions/core/feature_flags/feature_flag_service.dart';
import 'package:hairextensions/core/feature_flags/feature_module.dart';
import 'package:hairextensions/core/logger/app_logger.dart';
import 'package:hairextensions/core/monitoring/crash/non_fatal.dart';
import 'package:injectable/injectable.dart';

/// Initializes enabled feature modules after the first frame, and later ones
/// as soon as Remote Config switches them on.
@lazySingleton
class FeatureModuleRegistry {
  FeatureModuleRegistry(this._flags);

  static const String _source = 'FeatureModuleRegistry';

  final FeatureFlagService _flags;
  final List<FeatureModule> _modules = [];
  final Set<FeatureModule> _initialized = {};
  bool _listening = false;

  void registerAll(Iterable<FeatureModule> modules) => _modules.addAll(modules);

  Future<void> initializeEnabled() async {
    if (!_listening) {
      _listening = true;
      _flags.addListener(_onFlagsChanged);
    }
    for (final module in _modules) {
      if (_initialized.contains(module) || !_flags.isEnabled(module.feature)) {
        continue;
      }
      _initialized.add(module);
      try {
        await module.initialize();
      } on Object catch (error, stackTrace) {
        _initialized.remove(module);
        AppLogger.error(_source, '${module.feature.name} init failed', error);
        NonFatal.record(error, stackTrace, reason: module.feature.name);
      }
    }
  }

  void _onFlagsChanged() => unawaited(initializeEnabled());

  @disposeMethod
  void dispose() => _flags.removeListener(_onFlagsChanged);
}
