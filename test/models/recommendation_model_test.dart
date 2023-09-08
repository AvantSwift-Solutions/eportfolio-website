import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/Recommendation.dart';

void main() {
  group('Recommendation class tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('Recommendation.toMap should convert recommendation to a map', () {
      final recommendation = Recommendation(
        rid: 'rid123',
        colleagueName: 'Steve Jobs',
        colleagueJobTitle: 'CEO',
        description: 'This is a recommendation',
        imageURL: 'https://example.com/image.jpg',
      );
      final recommendationMap = recommendation.toMap();

      expect(recommendationMap['rid'], 'rid123');
      expect(recommendationMap['colleagueName'], 'Steve Jobs');
      expect(recommendationMap['colleagueJobTitle'], 'CEO');
      expect(recommendationMap['description'], 'This is a recommendation');
      expect(recommendationMap['imageURL'], 'https://example.com/image.jpg');
    });

  });
}