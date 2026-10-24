import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/detail/quote_detail_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/pages/detail/quote_detail_view.dart';

class QuoteDetailPage extends StatelessWidget {
  const QuoteDetailPage({required this.quoteId, super.key});

  final String quoteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<QuoteDetailCubit>()..start(quoteId), child: const QuoteDetailView());
  }
}
