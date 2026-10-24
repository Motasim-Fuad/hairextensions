import 'package:equatable/equatable.dart';

/// Semantic version without build metadata; "1.4.2+17" parses as 1.4.2.
class AppVersion extends Equatable implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch);

  static const AppVersion zero = AppVersion(0, 0, 0);

  final int major;
  final int minor;
  final int patch;

  static AppVersion? tryParse(String? raw) {
    if (raw == null) {
      return null;
    }
    final core = raw.trim().split('+').first.split('-').first;
    if (core.isEmpty) {
      return null;
    }
    final parts = core.split('.');
    final numbers = <int>[];
    for (final part in parts) {
      final value = int.tryParse(part);
      if (value == null || value < 0) {
        return null;
      }
      numbers.add(value);
    }
    while (numbers.length < 3) {
      numbers.add(0);
    }
    return AppVersion(numbers[0], numbers[1], numbers[2]);
  }

  bool operator <(AppVersion other) => compareTo(other) < 0;

  @override
  int compareTo(AppVersion other) {
    if (major != other.major) {
      return major.compareTo(other.major);
    }
    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }
    return patch.compareTo(other.patch);
  }

  @override
  List<Object?> get props => [major, minor, patch];

  @override
  String toString() => '$major.$minor.$patch';
}
