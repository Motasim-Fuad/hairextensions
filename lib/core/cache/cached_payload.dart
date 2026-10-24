import 'package:equatable/equatable.dart';

class CachedPayload extends Equatable {
  const CachedPayload({required this.payload, required this.isExpired});

  final String payload;
  final bool isExpired;

  @override
  List<Object?> get props => [payload, isExpired];
}
