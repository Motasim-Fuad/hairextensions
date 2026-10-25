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

  test('reads the Price to Profit error envelope', () {
    final body = {
      'error': {
        'code': 'validation_error',
        'message': 'The request is not valid.',
        'details': [
          {
            'location': ['body', 'quote_prefix'],
            'message': 'String should match pattern',
            'type': 'string_pattern_mismatch',
          },
        ],
      },
    };

    expect(FastApiErrorParser.message(body), 'The request is not valid.');
    expect(FastApiErrorParser.code(body), 'validation_error');
    expect(FastApiErrorParser.fieldErrors(body), {'quote_prefix': 'String should match pattern'});
  });

  test('returns null for unknown shapes', () {
    expect(FastApiErrorParser.message({'error': 1}), isNull);
    expect(FastApiErrorParser.fieldErrors('oops'), isEmpty);
  });
}
