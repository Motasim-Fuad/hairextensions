import 'package:injectable/injectable.dart';

/// Injectable time source so time-based logic is testable.
@lazySingleton
class Clock {
  DateTime now() => DateTime.now();
}
