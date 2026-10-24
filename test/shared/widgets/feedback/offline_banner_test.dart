import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/core/connectivity/connectivity_cubit.dart';
import 'package:hairextensions/core/connectivity/connectivity_status.dart';
import 'package:hairextensions/shared/widgets/feedback/offline_banner.dart';
import 'package:hairextensions/shared/widgets/feedback/offline_banner_content.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks/mock_connectivity_cubit.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late MockConnectivityCubit cubit;

  setUp(() => cubit = MockConnectivityCubit());

  Future<void> pump(WidgetTester tester) {
    return tester.pumpApp(
      BlocProvider<ConnectivityCubit>.value(value: cubit, child: const OfflineBanner()),
    );
  }

  testWidgets('shows the banner while offline', (tester) async {
    when(() => cubit.state).thenReturn(ConnectivityStatus.offline);

    await pump(tester);

    expect(find.byType(OfflineBannerContent), findsOneWidget);
  });

  testWidgets('hides the banner while online', (tester) async {
    when(() => cubit.state).thenReturn(ConnectivityStatus.online);

    await pump(tester);

    expect(find.byType(OfflineBannerContent), findsNothing);
  });
}
