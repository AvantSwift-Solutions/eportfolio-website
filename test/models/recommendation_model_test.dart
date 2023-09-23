import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/Recommendation.dart';

void main() {
  group('Recommendation Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

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
