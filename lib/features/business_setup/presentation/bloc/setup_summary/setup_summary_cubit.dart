import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/errors/failures/failure.dart';
import 'package:hairextensions/core/shared_entities/business_profile.dart';
import 'package:hairextensions/features/business_setup/domain/usecases/get_business_profile.dart';
import 'package:hairextensions/features/business_setup/presentation/bloc/setup_summary/setup_summary_status.dart';
import 'package:injectable/injectable.dart';

part 'setup_summary_state.dart';

@injectable
class SetupSummaryCubit extends Cubit<SetupSummaryState> {
  SetupSummaryCubit(this._getProfile) : super(const SetupSummaryState.initial());

  final GetBusinessProfile _getProfile;

  Future<void> load() async {
    emit(const SetupSummaryState.initial());
    final result = await _getProfile();
    result.match(
      (failure) => emit(SetupSummaryState(status: SetupSummaryStatus.failure, failure: failure)),
      (profile) => emit(
        profile == null
            ? const SetupSummaryState(status: SetupSummaryStatus.failure, failure: NotFoundFailure())
            : SetupSummaryState(status: SetupSummaryStatus.ready, profile: profile),
      ),
    );
  }
}
