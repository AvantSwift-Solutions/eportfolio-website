import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:avantswift_portfolio/models/ProfessionalExperience.dart';

void main() {
  group('ProfessionalExperience class tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('ProfessionalExperience.toMap should convert education to a map', () {
      final professionalExperience = ProfessionalExperience(
        professionalExperienceId: 'exp123',
        jobTitle: 'Scrum Master',
        companyName: 'TikTok',
        location: 'New York',
        startDate: Timestamp(1234567890, 0),
        endDate: Timestamp(1234567890, 0),
        logoURL: 'https://example.com/image.jpg',
        description: 'This is my job',
      );
      final professionalExperienceMap = professionalExperience.toMap();

      expect(professionalExperienceMap['eid'], 'edu123');
      expect(professionalExperienceMap['jobTitle'], 'Scrum Master');
      expect(professionalExperienceMap['companyName'], 'TikTok');
      expect(professionalExperienceMap['location'], 'New York');
      expect(professionalExperienceMap['startDate'], Timestamp(1234567890, 0));
      expect(professionalExperienceMap['endDate'], Timestamp(1234567890, 0));
      expect(professionalExperienceMap['logoURL'], 'https://example.com/image.jpg');
      expect(professionalExperienceMap['description'], 'This is my job');
    });

  });
}