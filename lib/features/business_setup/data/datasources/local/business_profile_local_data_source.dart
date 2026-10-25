import 'package:hairextensions/features/business_setup/data/models/business_profile_model.dart';

abstract interface class BusinessProfileLocalDataSource {
  Future<BusinessProfileModel?> read();

  Future<void> upsert(BusinessProfileModel model);

  /// Removes the stored profile, used when the account signs out.
  Future<void> clear();

  /// Emits after every [upsert]. Does not replay the current value.
  Stream<BusinessProfileModel> get changes;

  Future<void> dispose();
}
