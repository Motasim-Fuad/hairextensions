import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/config/app_config.dart';
import 'package:hairextensions/core/config/app_environment.dart';
import 'package:hairextensions/core/contracts/business_profile_reader.dart';
import 'package:hairextensions/core/contracts/catalog_reader.dart';
import 'package:hairextensions/core/feature_flags/app_gate_service.dart';
import 'package:hairextensions/core/links/link_launcher.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/core/subscription/subscription_service.dart';
import 'package:hairextensions/core/subscription/subscription_status.dart';
import 'package:hairextensions/features/settings/presentation/bloc/settings_error.dart';
import 'package:injectable/injectable.dart';
import 'package:hairextensions/features/auth/domain/repositories/auth_repository.dart';
part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._profiles, this._catalog, this._subscription, this._config, this._links,this._authRepository, AppGateService gate)
    : super(SettingsState(isPro: _subscription.isPro, version: gate.installedVersion));

  static const String _manageSubscriptionsUrl = 'https://apps.apple.com/account/subscriptions';
  static const String _mailScheme = 'mailto:';

  final BusinessProfileReader _profiles;
  final CatalogReader _catalog;
  final SubscriptionService _subscription;
  final AppConfig _config;
  final LinkLauncher _links;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  final AuthRepository _authRepository;

  void start() {
    _subscription.addListener(_onSubscription);
    _subscriptions
      ..add(_profiles.watch().listen((profile) => emit(state.copyWith(profile: profile))))
      ..add(_catalog.watchProducts().listen((items) => emit(state.copyWith(productCount: items.length))))
      ..add(_catalog.watchMaterials().listen((items) => emit(state.copyWith(materialCount: items.length))))
      ..add(_catalog.watchServices().listen((items) => emit(state.copyWith(serviceCount: items.length))));
  }

  void _onSubscription() => emit(state.copyWith(isPro: _subscription.isPro));

  Future<void> openPrivacy() => _open(_config.privacyPolicyUrl);

  Future<void> openTerms() => _open(_config.termsUrl);

  Future<void> contactSupport() => _open('$_mailScheme${_config.supportEmail}');

  Future<void> manageSubscription() => _open(_manageSubscriptionsUrl);

  /// Store billing is not wired yet; the mock environment restores locally.
  Future<void> restore() async {
    if (_config.environment != AppEnvironment.mock) {
      emit(state.copyWith(errorKind: SettingsError.purchase));
      return;
    }
    await _subscription.save(SubscriptionStatus.active);
    emit(state.copyWith(clearError: true));
  }

  Future<void> _open(String url) async {
    final opened = await _links.open(url);
    if (!isClosed) {
      emit(opened ? state.copyWith(clearError: true) : state.copyWith(errorKind: SettingsError.link));
    }
  }


  Future<void> logout() async {
    await _authRepository.endSession();
  }
  @override
  Future<void> close() async {
    _subscription.removeListener(_onSubscription);
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
