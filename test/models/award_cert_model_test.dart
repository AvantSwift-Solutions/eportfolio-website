import 'package:flutter_test/flutter_test.dart';

import 'package:avantswift_portfolio/models/AwardCert.dart'; // Update this import based on your project structure

void main() {
  group('AwardCert Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('PersonalProject.toMap should convert personal project to a map', () {
      final awardCerts = AwardCert(
          acid: 'acid1',
          name: 'Certification 1',
          link: 'https://example.com/user/certification',
          source: 'Example source');
      final awardCertMap = awardCerts.toMap();

      expect(awardCertMap['acid'], 'acid1');
      expect(awardCertMap['name'], 'Certification 1');

      // Add more assertions for other properties
    });

    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
