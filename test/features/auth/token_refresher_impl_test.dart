import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/network/api_response/api_error_type.dart';
import 'package:hairextensions/core/network/api_response/api_response.dart';
import 'package:hairextensions/core/network/auth/token_refresh_unavailable_exception.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/auth/data/models/auth_tokens_model.dart';
import 'package:hairextensions/features/auth/data/services/token_refresher_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks/mock_auth_remote_data_source.dart';

void main() {
  late MockAuthRemoteDataSource remote;
  late TokenRefresherImpl refresher;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    refresher = TokenRefresherImpl(remote, Clock());
  });

  void stub(ApiResponse<AuthTokensModel> response) {
    when(() => remote.refresh(any())).thenAnswer((_) async => response);
  }

  test('returns new tokens on success', () async {
    stub(ApiResponse.success(const AuthTokensModel(accessToken: 'new', refreshToken: 'r2', expiresInSeconds: 60)));
    final tokens = await refresher.refresh('r1');
    expect(tokens?.accessToken, 'new');
    expect(tokens?.expiresAt, isNotNull);
  });

  test('a rejected refresh token ends the session', () async {
    stub(ApiResponse.failure(statusCode: 401));
    expect(await refresher.refresh('r1'), isNull);
  });

  test('an unreachable server keeps the session', () async {
    stub(ApiResponse.failure(errorType: ApiErrorType.network));
    expect(() => refresher.refresh('r1'), throwsA(isA<TokenRefreshUnavailableException>()));
  });
}
