part of 'setup_summary_cubit.dart';

final class SetupSummaryState extends Equatable {
  const SetupSummaryState({required this.status, this.profile, this.failure});

  const SetupSummaryState.initial() : this(status: SetupSummaryStatus.loading);

  final SetupSummaryStatus status;
  final BusinessProfile? profile;
  final Failure? failure;

  @override
  List<Object?> get props => [status, profile, failure];
}
