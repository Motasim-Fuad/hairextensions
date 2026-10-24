import 'package:hairextensions/core/network/auth/token_refresh_unavailable_exception.dart';
import 'package:hairextensions/core/network/auth/token_refresher.dart';
import 'package:hairextensions/core/shared_entities/auth_tokens.dart';
import 'package:hairextensions/core/utils/clock.dart';
import 'package:hairextensions/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:injectable/injectable.dart';

/// Client errors (401, 403, 4xx) reject the refresh token and end the session.
/// Network failures, timeouts and server errors keep it for a later retry.
@LazySingleton(as: TokenRefresher)
class TokenRefresherImpl implements TokenRefresher {
  TokenRefresherImpl(this._remote, this._clock);

  final AuthRemoteDataSource _remote;
  final Clock _clock;

  @override
  Future<AuthTokens?> refresh(String refreshToken) async {
    final response = await _remote.refresh(refreshToken);
    final model = response.data;
    if (response.isSuccess && model != null) {
      return model.toEntity(_clock.now());
    }
    if (response.isClientError) {
      return null;
    }
    throw TokenRefreshUnavailableException('${response.errorType}');
  }
}
