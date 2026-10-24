import 'package:crypto/crypto.dart';

/// SHA-256 of a certificate's DER bytes, as lowercase hex. Pins may be
/// written with colons or in upper case, as most tools print them.
abstract final class CertificateFingerprint {
  static final RegExp _separators = RegExp(r'[\s:]');

  static String sha256Of(List<int> der) => sha256.convert(der).toString();

  static String normalize(String pin) => pin.replaceAll(_separators, '').toLowerCase();

  static bool matches(List<int> der, Iterable<String> pins) {
    final actual = sha256Of(der);
    return pins.any((pin) => normalize(pin) == actual);
  }
}
