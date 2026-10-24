import 'package:bloc_test/bloc_test.dart';
import 'package:hairextensions/core/connectivity/connectivity_cubit.dart';
import 'package:hairextensions/core/connectivity/connectivity_status.dart';

class MockConnectivityCubit extends MockCubit<ConnectivityStatus> implements ConnectivityCubit {}
