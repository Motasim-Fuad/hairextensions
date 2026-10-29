import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/builder/quote_builder_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/pages/builder/quote_builder_view.dart';

class QuoteBuilderPage extends StatelessWidget {
  const QuoteBuilderPage({super.key, this.template, this.editing = false});

  final Quote? template;
  final bool editing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<QuoteBuilderCubit>();
        unawaited(cubit.start(template: template, editing: editing));
        return cubit;
      },
      child: const QuoteBuilderView(),
    );
  }
}
