import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/network/mappers/fast_api_error_parser.dart';

void main() {
  test('reads a plain detail string', () {
    expect(FastApiErrorParser.message({'detail': 'Invalid code'}), 'Invalid code');
  });

  test('reads the first validation message and maps field errors', () {
    final body = {
      'detail': [
        {
          'loc': ['body', 'email'],
          'msg': 'value is not a valid email address',
        },
        {
          'loc': ['body', 'phone'],
          'msg': 'field required',
        },
      ],
    };

    expect(FastApiErrorParser.message(body), 'value is not a valid email address');
    expect(FastApiErrorParser.fieldErrors(body), {
      'email': 'value is not a valid email address',
      'phone': 'field required',
    });
  });

  test('returns null for unknown shapes', () {
    expect(FastApiErrorParser.message({'error': 1}), isNull);
    expect(FastApiErrorParser.fieldErrors('oops'), isEmpty);
  });
}
