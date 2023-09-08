import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/ISkill.dart';

void main() {
  group('ISkill Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('ISkill.toMap should convert iskill to a map', () {
      final iskill = ISkill(
        isid: 'iskill123',
        name: 'mockISkill',
      );
      final iskillMap = iskill.toMap();

      expect(iskillMap['isid'], 'iskill123');
      expect(iskillMap['name'], 'mockISkill');
    });

  });
}