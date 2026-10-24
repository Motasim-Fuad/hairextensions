import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hairextensions/core/contracts/pro_gate.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/core/routing/app_routes.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';

/// Quote navigation shared by home, history and detail.
extension QuoteNavigation on BuildContext {
  /// New quotes are Pro-only; the gate shows the lock sheet when needed.
  /// [template] pre-fills the builder (duplicate).
  Future<void> startNewQuote({Quote? template}) async {
    final allowed = await getIt<ProGate>().ensurePro(this);
    if (allowed && mounted) {
      unawaited(pushNamed<void>(AppRoutes.newQuote, extra: template));
    }
  }

  void openQuote(String id) {
    unawaited(pushNamed<void>(AppRoutes.quoteDetail, pathParameters: {AppRoutes.idParam: id}));
  }

  void openQuotePreview(String id) {
    unawaited(pushNamed<void>(AppRoutes.quotePreview, pathParameters: {AppRoutes.idParam: id}));
  }
}
