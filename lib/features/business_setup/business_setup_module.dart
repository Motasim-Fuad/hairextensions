import 'package:hairextensions/core/feature_flags/feature_key.dart';
import 'package:hairextensions/core/feature_flags/feature_module.dart';
import 'package:hairextensions/core/sync/sync_handler_registry.dart';
import 'package:hairextensions/features/business_setup/data/sync/business_profile_sync_handler.dart';
import 'package:injectable/injectable.dart';

/// Pushing to the server only starts once cloud sync is switched on remotely.
/// Until then saves stay in the queue, coalesced to one pending row.
@lazySingleton
class BusinessSetupModule implements FeatureModule {
  BusinessSetupModule(this._registry, this._handler);

  final SyncHandlerRegistry _registry;
  final BusinessProfileSyncHandler _handler;

  @override
  FeatureKey get feature => FeatureKey.cloudSync;

  @override
  Future<void> initialize() async => _registry.register(_handler);
}
