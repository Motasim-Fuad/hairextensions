import 'package:hairextensions/app/bootstrap/bootstrap.dart';

/// Flavor and environment come from `--dart-define-from-file=config/dev.json`
/// (or mock, staging, prod).
Future<void> main() => bootstrap();
