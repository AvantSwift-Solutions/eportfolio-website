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
        jobTitle: 'Scrum Master',
        companyName: 'TikTok',
        location: 'New York',
        startDate: Timestamp(1234567890, 0),
        endDate: Timestamp(1234567890, 0),
        logoURL: 'https://example.com/image.jpg',
        description: 'This is my job',
      );
      final ExperienceMap = experience.toMap();

      expect(ExperienceMap['peid'], 'exp123');
      expect(ExperienceMap['jobTitle'], 'Scrum Master');
      expect(ExperienceMap['companyName'], 'TikTok');
      expect(ExperienceMap['location'], 'New York');
      expect(ExperienceMap['startDate'], Timestamp(1234567890, 0));
      expect(ExperienceMap['endDate'], Timestamp(1234567890, 0));
      expect(ExperienceMap['logoURL'], 'https://example.com/image.jpg');
      expect(ExperienceMap['description'], 'This is my job');
    });

  });
}