import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/TSkill.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('TSkill Model tests', () {
    test('fromDocumentSnapshot should return an TSkill object', () {
      final data = {
        'creationTimestamp': Timestamp.now(),
        'tsid': 'tskill123',
        'index': 0,
        'name': 'mockTSkill',
        'imageURL': 'https://example.com/image.jpg',
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = TSkill.fromDocumentSnapshot(snapshot);

      expect(result.creationTimestamp, data['creationTimestamp']);
      expect(result.tsid, 'tskill123');
      expect(result.index, 0);
      expect(result.name, 'mockTSkill');
      expect(result.imageURL, 'https://example.com/image.jpg');
    });

    test('TSkill.toMap should convert tskill to a map', () {
      final tskill = TSkill(
          creationTimestamp: Timestamp.now(),
          tsid: 'tskill123',
          index: 0,
          name: 'mockTSkill',
          imageURL: 'https://example.com/image.jpg');
      final tskillMap = tskill.toMap();

      expect(tskillMap['creationTimestamp'], tskill.creationTimestamp);
      expect(tskillMap['tsid'], 'tskill123');
      expect(tskillMap['index'], 0);
      expect(tskillMap['name'], 'mockTSkill');
      expect(tskillMap['imageURL'], 'https://example.com/image.jpg');
    });
  });
}
