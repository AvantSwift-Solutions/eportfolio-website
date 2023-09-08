import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/TSkill.dart';

void main() {
  group('TSkill Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('TSkill.toMap should convert tskill to a map', () {
      final tskill = TSkill(
        tsid: 'tskill123',
        name: 'mockTSkill',
        imageURL: 'https://example.com/image.jpg'
      );
      final tskillMap = tskill.toMap();

      expect(tskillMap['tsid'], 'tskill123');
      expect(tskillMap['name'], 'mockTSkill');
      expect(tskillMap['imageURL'], 'https://example.com/image.jpg');
    });

  });
}