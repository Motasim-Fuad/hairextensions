import 'package:equatable/equatable.dart';
import 'package:hairextensions/features/quotes/domain/entities/quote_activity_type.dart';

class QuoteActivity extends Equatable {
  const QuoteActivity({required this.type, required this.at});

  final QuoteActivityType type;
  final DateTime at;

  @override
  List<Object?> get props => [type, at];
}
