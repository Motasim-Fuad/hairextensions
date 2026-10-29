import 'package:hairextensions/core/feature_flags/app_gate_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/config/app_environment.dart';
import 'package:hairextensions/core/links/link_launcher.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';
import 'package:hairextensions/features/paywall/domain/entities/paywall_plan.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_failure.dart';
import 'package:hairextensions/features/paywall/presentation/bloc/paywall_state.dart';
import 'package:injectable/injectable.dart';

/// Store billing is not wired yet: mock and non-production builds unlock Pro
/// locally so the full flow can be tried; production reports an inline error.
@injectable
class PaywallCubit extends Cubit<PaywallState> {
  PaywallCubit(this._subscription, this._config, this._links, [this._gate])
    : super(const PaywallState());

  final SubscriptionService _subscription;
  final AppConfig _config;
  final LinkLauncher _links;
  final AppGateService? _gate;

  bool get _canMockPurchase => _config.environment == AppEnvironment.mock;

  bool get billingAvailable => _canMockPurchase;

  void selectPlan(PaywallPlan plan) => emit(state.copyWith(plan: plan));

  Future<void> startTrial() => _unlock();

  Future<void> restore() => _unlock();

  Future<void> openTerms() => _open(
    (_gate?.links.termsUrl.isNotEmpty ?? false)
        ? _gate!.links.termsUrl
        : _config.termsUrl,
  );

  Future<void> openPrivacy() => _open(
    (_gate?.links.privacyUrl.isNotEmpty ?? false)
        ? _gate!.links.privacyUrl
        : _config.privacyPolicyUrl,
  );

  Future<void> _unlock() async {
    if (state.isPurchasing) {
      return;
    }
    if (!_canMockPurchase) {
      emit(state.copyWith(failure: PaywallFailure.purchase));
      return;
    }
    emit(state.copyWith(isPurchasing: true));
    await _subscription.save(SubscriptionStatus.active);
    emit(state.copyWith(isPurchasing: false, isUnlocked: true));
  }

  Future<void> _open(String url) async {
    final opened = await _links.open(url);
    emit(state.copyWith(failure: opened ? null : PaywallFailure.link));
  }
}
