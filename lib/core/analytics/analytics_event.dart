import 'package:equatable/equatable.dart';

/// Names follow Firebase rules: snake_case, starts with a letter, at most 40
/// characters. Parameter values must be String or num.
class AnalyticsEvent extends Equatable {
  AnalyticsEvent(this.name, [this.parameters = const {}])
    : assert(_validName.hasMatch(name), 'Invalid analytics event name: $name');

  static final RegExp _validName = RegExp(r'^[a-z][a-z0-9_]{0,39}$');

  final String name;
  final Map<String, Object> parameters;

  @override
  List<Object?> get props => [name, parameters];
}
