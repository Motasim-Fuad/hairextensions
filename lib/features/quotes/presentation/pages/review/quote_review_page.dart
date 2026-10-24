import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/di/injection.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote.dart';
import 'package:hairextensions/features/quotes/presentation/bloc/review/quote_review_cubit.dart';
import 'package:hairextensions/features/quotes/presentation/pages/review/quote_review_view.dart';

class QuoteReviewPage extends StatelessWidget {
  const QuoteReviewPage({required this.quote, super.key});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QuoteReviewCubit>(param1: quote),
      child: const QuoteReviewView(),
    );
  }
}
