import 'package:hairextensions/core/shared_entities/business_profile.dart';

/// Read-only access to the business profile for features other than
/// business_setup (quotes, PDF, settings, home).
abstract interface class BusinessProfileReader {
  Future<BusinessProfile?> read();

  /// Emits the current profile, then every saved change.
  Stream<BusinessProfile?> watch();
}
