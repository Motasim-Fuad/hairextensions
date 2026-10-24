import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/preview/quote_preview_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/pages/preview/quote_preview_view.dart';

class QuotePreviewPage extends StatelessWidget {
  const QuotePreviewPage({required this.quoteId, super.key});

  final String quoteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<QuotePreviewCubit>();
        unawaited(cubit.start(quoteId));
        return cubit;
      },
      child: const QuotePreviewView(),
    );
  }
}
