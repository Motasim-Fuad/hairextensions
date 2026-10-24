import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/monitoring/app_bloc_observer.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks/mock_crash_reporter.dart';

class _FailingCubit extends Cubit<int> {
  _FailingCubit() : super(0);

  void fail() => addError(StateError('boom'), StackTrace.current);
}

void main() {
  late MockCrashReporter crashReporter;
  late BlocObserver previous;

  setUpAll(() => registerFallbackValue(StackTrace.empty));

  setUp(() {
    crashReporter = MockCrashReporter();
    when(
      () => crashReporter.recordError(any(), any(), reason: any(named: 'reason')),
    ).thenAnswer((_) async {});
    previous = Bloc.observer;
    Bloc.observer = AppBlocObserver(crashReporter);
  });

  tearDown(() => Bloc.observer = previous);

  test('forwards bloc errors to the crash reporter as non-fatals', () async {
    final cubit = _FailingCubit()..fail();
    await cubit.close();

    verify(
      () => crashReporter.recordError(isA<StateError>(), any(), reason: '_FailingCubit'),
    ).called(1);
  });
}
