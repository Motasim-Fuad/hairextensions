import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/network/security/certificate_fingerprint.dart';

void main() {
  final der = utf8.encode('certificate');
  const hex = 'a4ad7ebe1c9cb48cc6dc14c94a7bd1af2a8ed7f8f2d1a1c4d3b6a57b2c91e26a';

  test('hashes DER bytes as lowercase hex', () {
    final fingerprint = CertificateFingerprint.sha256Of(der);
    expect(fingerprint, hasLength(64));
    expect(fingerprint, fingerprint.toLowerCase());
  });

  test('accepts pins written with colons and upper case', () {
    final actual = CertificateFingerprint.sha256Of(der);
    final pretty = [
      for (var index = 0; index < actual.length; index += 2) actual.substring(index, index + 2).toUpperCase(),
    ].join(':');
    expect(CertificateFingerprint.matches(der, [pretty]), isTrue);
  });

  test('rejects a certificate that matches no pin', () {
    expect(CertificateFingerprint.matches(der, [hex]), isFalse);
    expect(CertificateFingerprint.matches(der, const []), isFalse);
  });
}
