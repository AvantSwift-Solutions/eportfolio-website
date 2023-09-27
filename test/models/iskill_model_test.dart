import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/ISkill.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('ISkill Model tests', () {
    test('fromDocumentSnapshot should return an ISkill object', () {
      final data = {
        'creationTimestamp': Timestamp.now(),
        'isid': 'iskill123',
        'index': 0,
        'name': 'mockISkill',
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = ISkill.fromDocumentSnapshot(snapshot);

      expect(result.creationTimestamp, data['creationTimestamp']);
      expect(result.isid, 'iskill123');
      expect(result.index, 0);
      expect(result.name, 'mockISkill');
    });

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
