part of 'quote_preview_cubit.dart';

final class QuotePreviewState extends Equatable {
  const QuotePreviewState({
    required this.status,
    this.quote,
    this.profile,
    this.mode = DocumentMode.client,
    this.isSharing = false,
    this.failure,
  });

  final ViewStatus status;
  final Quote? quote;
  final BusinessProfile? profile;
  final DocumentMode mode;
  final bool isSharing;
  final Failure? failure;

  QuotePreviewState copyWith({
    ViewStatus? status,
    Quote? quote,
    BusinessProfile? profile,
    DocumentMode? mode,
    bool? isSharing,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return QuotePreviewState(
      status: status ?? this.status,
      quote: quote ?? this.quote,
      profile: profile ?? this.profile,
      mode: mode ?? this.mode,
      isSharing: isSharing ?? this.isSharing,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, quote, profile, mode, isSharing, failure];
}
