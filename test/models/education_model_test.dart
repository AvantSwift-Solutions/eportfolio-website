import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:avantswift_portfolio/models/Education.dart';

void main() {
  group('Education Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('Education.toMap should convert education to a map', () {
      final education = Education(
        creationTimestamp: Timestamp.now(),
        eid: 'edu123',
        index: 0,
        startDate: Timestamp(1234567890, 0),
        endDate: Timestamp(1234567890, 0),
        logoURL: 'https://example.com/image.jpg',
        schoolName: 'University of Example',
        degree: 'Degree name',
        description: 'This is a degree',
        major: 'Major name',
        grade: 90,
        gradeDescription: 'First Class Honours',
      );
      final educationMap = education.toMap();

      expect(educationMap['creationTimestamp'], education.creationTimestamp);
      expect(educationMap['eid'], 'edu123');
      expect(educationMap['index'], 0);
      expect(educationMap['startDate'], Timestamp(1234567890, 0));
      expect(educationMap['endDate'], Timestamp(1234567890, 0));
      expect(educationMap['logoURL'], 'https://example.com/image.jpg');
      expect(educationMap['schoolName'], 'University of Example');
      expect(educationMap['degree'], 'Degree name');
      expect(educationMap['description'], 'This is a degree');
      expect(educationMap['major'], 'Major name');
      expect(educationMap['grade'], 90);
      expect(educationMap['gradeDescription'], 'First Class Honours');
    });
  });
}
