import 'package:equatable/equatable.dart';

class SegmentOption<T> extends Equatable {
  const SegmentOption({required this.value, required this.label});

  final T value;
  final String label;

  @override
  List<Object?> get props => [value, label];
}
