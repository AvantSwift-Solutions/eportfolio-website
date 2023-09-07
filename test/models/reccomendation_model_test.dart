import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/Reccomendation.dart';

void main() {
  group('Reccomendation class tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('Reccomendation.toMap should convert reccomendation to a map', () {
      final reccomendation = Reccomendation(
        rid: 'rid123',
        colleagueName: 'Steve Jobs',
        colleagueJobTitle: 'CEO',
        description: 'This is a reccomendation',
        imageURL: 'https://example.com/image.jpg',
      );
      final reccomendationMap = reccomendation.toMap();

      expect(reccomendationMap['rid'], 'rid123');
      expect(reccomendationMap['colleagueName'], 'Steve Jobs');
      expect(reccomendationMap['colleagueJobTitle'], 'CEO');
      expect(reccomendationMap['description'], 'This is a reccomendation');
      expect(reccomendationMap['imageURL'], 'https://example.com/image.jpg');
    });

  });
}