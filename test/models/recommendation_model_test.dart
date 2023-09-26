import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/Recommendation.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('Recommendation Model tests', () {
    test('fromDocumentSnapshot should return a Recommendation object', () {
      final data = {
        'creationTimestamp': Timestamp.now(),
        'rid': '123',
        'index': 1,
        'colleagueName': 'Test Colleague',
        'colleagueJobTitle': 'Test Job Title',
        'description': 'Test Description',
        'imageURL': 'https://example.com/image.jpg',
        'dateReceived': Timestamp.now(),
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = Recommendation.fromDocumentSnapshot(snapshot);

      expect(result.creationTimestamp, data['creationTimestamp']);
      expect(result.rid, '123');
      expect(result.index, 1);
      expect(result.colleagueName, 'Test Colleague');
      expect(result.colleagueJobTitle, 'Test Job Title');
      expect(result.description, 'Test Description');
      expect(result.imageURL, 'https://example.com/image.jpg');
      expect(result.dateReceived, data['dateReceived']);
    });

    test('Recommendation.toMap should convert recommendation to a map', () {
      final recommendation = Recommendation(
        creationTimestamp: Timestamp.now(),
        rid: 'rid123',
        index: 0,
        colleagueName: 'Steve Jobs',
        colleagueJobTitle: 'CEO',
        description: 'This is a recommendation',
        imageURL: 'https://example.com/image.jpg',
        dateReceived: Timestamp(1234567890, 0),
      );
      final recommendationMap = recommendation.toMap();

      expect(recommendationMap['creationTimestamp'],
          recommendation.creationTimestamp);
      expect(recommendationMap['rid'], 'rid123');
      expect(recommendationMap['index'], 0);
      expect(recommendationMap['colleagueName'], 'Steve Jobs');
      expect(recommendationMap['colleagueJobTitle'], 'CEO');
      expect(recommendationMap['description'], 'This is a recommendation');
      expect(recommendationMap['imageURL'], 'https://example.com/image.jpg');
      expect(recommendationMap['dateReceived'], Timestamp(1234567890, 0));
    });
  });
}
