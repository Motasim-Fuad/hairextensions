import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/history/quote_history_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/pages/history/quote_history_view.dart';

class QuoteHistoryPage extends StatelessWidget {
  const QuoteHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<QuoteHistoryCubit>()..start(), child: const QuoteHistoryView());
  }
}
