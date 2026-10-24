import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// Client-generated ids let records be created offline without collisions.
@lazySingleton
class IdGenerator {
  IdGenerator(this._uuid);

  final Uuid _uuid;

  String next() => _uuid.v4();
}
