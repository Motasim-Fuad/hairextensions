import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hairextensions/core/session/app_session.dart';
import 'package:injectable/injectable.dart';

/// Current onboarding page. Finishing (Skip or Get started) is remembered so
/// the guards never show onboarding again.
@injectable
class OnboardingCubit extends Cubit<int> {
  OnboardingCubit(this._session) : super(0);

  static const int pageCount = 3;

  final AppSession _session;

  bool get isLastPage => state == pageCount - 1;

  void showPage(int index) {
    if (index != state) {
      emit(index);
    }
  }

  Future<void> finish() => _session.markOnboardingSeen();
}
