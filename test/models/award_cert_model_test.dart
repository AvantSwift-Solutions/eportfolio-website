import 'package:flutter_test/flutter_test.dart';

import 'package:avantswift_portfolio/models/AwardCert.dart'; // Update this import based on your project structure

void main() {
  group('AwardCert class tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('PersonalProject.toMap should convert personal project to a map', () {
      final awardCerts = AwardCert(
        acid: '', 
        name: '', 
        link: '', 
        source: '');
      final awardCertMap = awardCerts.toMap();

      expect(awardCertMap['ppid'], 'user123');
      expect(awardCertMap['name'], 'Project 1');

      // Add more assertions for other properties
    });

    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}