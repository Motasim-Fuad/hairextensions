import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/feature_flags/feature_flag_defaults.dart';

/// The console template and the compiled defaults must agree, otherwise the
/// first launch and a fresh console behave differently.
void main() {
  test('firebase/remote_config_template.json matches FeatureFlagDefaults', () {
    final template =
        jsonDecode(File('firebase/remote_config_template.json').readAsStringSync()) as Map<String, Object?>;
    final groups = template['parameterGroups']! as Map<String, Object?>;
    final values = <String, String>{};
    for (final group in groups.values) {
      final parameters = (group! as Map<String, Object?>)['parameters']! as Map<String, Object?>;
      for (final entry in parameters.entries) {
        final defaultValue = (entry.value! as Map<String, Object?>)['defaultValue']! as Map<String, Object?>;
        values[entry.key] = defaultValue['value']! as String;
      }
    }

    expect(values, FeatureFlagDefaults.asStrings);
  });
}
