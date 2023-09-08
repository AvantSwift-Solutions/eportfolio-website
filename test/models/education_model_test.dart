import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:avantswift_portfolio/models/Education.dart';

void main() {
  group('Education Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('Education.toMap should convert education to a map', () {
      final education = Education(
        eid: 'edu123',
        startDate: Timestamp(1234567890, 0),
        endDate: Timestamp(1234567890, 0),
        logoURL: 'https://example.com/image.jpg',
        schoolName: 'University of Example',
        degree: 'Degree name',
        description: 'This is a degree',
      );
      final educationMap = education.toMap();

      expect(educationMap['eid'], 'edu123');
      expect(educationMap['startDate'], Timestamp(1234567890, 0));
      expect(educationMap['endDate'], Timestamp(1234567890, 0));
      expect(educationMap['logoURL'], 'https://example.com/image.jpg');
      expect(educationMap['schoolName'], 'University of Example');
      expect(educationMap['degree'], 'Degree name');
      expect(educationMap['description'], 'This is a degree');
    });

  });
}
