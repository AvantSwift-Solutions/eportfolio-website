import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('AwardCert Model tests', () {
    test('fromDocumentSnapshot should return an AwardCert object', () {
      final data = {
        'acid': '123',
        'creationTimestamp': Timestamp.now(),
        'index': 1,
        'name': 'Test Award',
        'imageURL': 'https://example.com/image.jpg',
        'link': 'https://example.com',
        'source': 'Test Source',
        'dateIssued': Timestamp.now(),
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = AwardCert.fromDocumentSnapshot(snapshot);

      expect(result.acid, '123');
      expect(result.creationTimestamp, data['creationTimestamp']);
      expect(result.index, 1);
      expect(result.name, 'Test Award');
      expect(result.imageURL, 'https://example.com/image.jpg');
      expect(result.link, 'https://example.com');
      expect(result.source, 'Test Source');
      expect(result.dateIssued, data['dateIssued']);
    });

    test('PersonalProject.toMap should convert personal project to a map', () {
      final awardCerts = AwardCert(
          creationTimestamp: Timestamp.now(),
          acid: 'acid1',
          index: 0,
          name: 'Certification 1',
          link: 'https://example.com/user/certification',
          source: 'Example source',
          imageURL: 'https://example.com/image.jpg',
          dateIssued: Timestamp(1234567890, 0));
      final awardCertMap = awardCerts.toMap();

      expect(awardCertMap['creationTimestamp'], awardCerts.creationTimestamp);
      expect(awardCertMap['acid'], 'acid1');
      expect(awardCertMap['index'], 0);
      expect(awardCertMap['name'], 'Certification 1');
      expect(awardCertMap['link'], 'https://example.com/user/certification');
      expect(awardCertMap['source'], 'Example source');
      expect(awardCertMap['imageURL'], 'https://example.com/image.jpg');
      expect(awardCertMap['dateIssued'], Timestamp(1234567890, 0));
    });

    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
