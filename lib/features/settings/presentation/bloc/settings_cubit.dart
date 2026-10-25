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
  SettingsCubit(this._profiles, this._catalog, this._subscription, this._config, this._links, this._authRepository, this._gate)
    : super(SettingsState(isPro: _subscription.isPro, version: _gate.installedVersion));

  static const String _manageSubscriptionsUrl = 'https://apps.apple.com/account/subscriptions';
  static const String _mailScheme = 'mailto:';
  static const String _whatsappBase = 'https://wa.me/';
  static final RegExp _nonDigits = RegExp('[^0-9]');

  final BusinessProfileReader _profiles;
  final CatalogReader _catalog;
  final SubscriptionService _subscription;
  final AppConfig _config;
  final LinkLauncher _links;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  final AuthRepository _authRepository;
  final AppGateService _gate;

  void start() {
    _subscription.addListener(_onSubscription);
    _subscriptions
      ..add(_profiles.watch().listen((profile) => emit(state.copyWith(profile: profile))))
      ..add(_catalog.watchProducts().listen((items) => emit(state.copyWith(productCount: items.length))))
      ..add(_catalog.watchMaterials().listen((items) => emit(state.copyWith(materialCount: items.length))))
      ..add(_catalog.watchServices().listen((items) => emit(state.copyWith(serviceCount: items.length))));
  }

  void _onSubscription() => emit(state.copyWith(isPro: _subscription.isPro));

  String get _privacyUrl => _gate.links.privacyUrl.isNotEmpty ? _gate.links.privacyUrl : _config.privacyPolicyUrl;

  String get _termsUrl => _gate.links.termsUrl.isNotEmpty ? _gate.links.termsUrl : _config.termsUrl;

  /// E-mail first, WhatsApp as the fallback; null when the backend has neither.
  String? get _supportUrl {
    final email = _gate.links.supportEmail.isNotEmpty ? _gate.links.supportEmail : _config.supportEmail;
    if (email.isNotEmpty) {
      return '$_mailScheme$email';
    }
    final digits = _gate.links.supportWhatsapp.replaceAll(_nonDigits, '');
    return digits.isEmpty ? null : '$_whatsappBase$digits';
  }

  bool get hasPrivacyLink => _privacyUrl.isNotEmpty;

  bool get hasTermsLink => _termsUrl.isNotEmpty;

  bool get hasSupportLink => _supportUrl != null;

  Future<void> manageSubscription() => _open(_manageSubscriptionsUrl);

  /// Store billing is not wired yet. Mock and non-production builds restore
  /// locally so the whole flow can be tried; production reports an error.
  Future<void> restore() async {
    if (_config.environment != AppEnvironment.mock && _config.isProduction) {
      emit(state.copyWith(errorKind: SettingsError.purchase));
      return;
    }
    await _subscription.save(SubscriptionStatus.active);
    emit(state.copyWith(clearError: true));
  }

  Future<void> openPrivacy() => _open(_privacyUrl);

  Future<void> openTerms() => _open(_termsUrl);

  Future<void> contactSupport() => _open(_supportUrl ?? '');

  Future<void> _open(String url) async {
    if (url.isEmpty) {
      emit(state.copyWith(errorKind: SettingsError.link));
      return;
    }
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
