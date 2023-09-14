import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:avantswift_portfolio/models/Experience.dart';

void main() {
  group('Experience Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('Experience.toMap should convert Experience to a map', () {
      final experience = Experience(
        peid: 'exp123',
        index: 1,
        jobTitle: 'Scrum Master',
        companyName: 'TikTok',
        location: 'New York',
        startDate: Timestamp(1234567890, 0),
        endDate: Timestamp(1234567890, 0),
        logoURL: 'https://example.com/image.jpg',
        description: 'This is my job',
      );
      final experienceMap = experience.toMap();

      expect(experienceMap['peid'], 'exp123');
      expect(experienceMap['index'], 1);
      expect(experienceMap['jobTitle'], 'Scrum Master');
      expect(experienceMap['companyName'], 'TikTok');
      expect(experienceMap['location'], 'New York');
      expect(experienceMap['startDate'], Timestamp(1234567890, 0));
      expect(experienceMap['endDate'], Timestamp(1234567890, 0));
      expect(experienceMap['logoURL'], 'https://example.com/image.jpg');
      expect(experienceMap['description'], 'This is my job');
    });
  });
}
