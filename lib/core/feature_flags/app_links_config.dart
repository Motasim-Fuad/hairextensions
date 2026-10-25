import 'package:equatable/equatable.dart';

/// Legal and support contacts published by the backend (`GET /v1/app-config`).
/// An empty value means the backend has none, and the app hides that entry
/// instead of showing a dead link.
class AppLinksConfig extends Equatable {
  const AppLinksConfig({
    required this.termsUrl,
    required this.privacyUrl,
    required this.supportEmail,
    required this.supportWhatsapp,
  });

  final String termsUrl;
  final String privacyUrl;
  final String supportEmail;
  final String supportWhatsapp;

  @override
  List<Object?> get props => [termsUrl, privacyUrl, supportEmail, supportWhatsapp];
}
