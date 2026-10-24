import 'package:flutter_test/flutter_test.dart';
import 'package:hairextensions/shared/widgets/media/monogram_avatar.dart';

void main() {
  test('takes up to two initials', () {
    expect(MonogramAvatar.initialsOf('Glam Strands Studio'), 'GS');
    expect(MonogramAvatar.initialsOf('  amna  '), 'A');
    expect(MonogramAvatar.initialsOf(''), '');
  });
}
