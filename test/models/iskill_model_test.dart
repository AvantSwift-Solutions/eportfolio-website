import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/ISkill.dart';

void main() {
  group('ISkill Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('ISkill.toMap should convert iskill to a map', () {
      final iskill = ISkill(
        creationTimestamp: Timestamp.now(),
        isid: 'iskill123',
        index: 0,
        name: 'mockISkill',
      );
      final iskillMap = iskill.toMap();

      expect(iskillMap['creationTimestamp'], iskill.creationTimestamp);
      expect(iskillMap['isid'], 'iskill123');
      expect(iskillMap['index'], 0);
      expect(iskillMap['name'], 'mockISkill');
    });
  });
}
