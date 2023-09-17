import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:avantswift_portfolio/models/AwardCert.dart'; // Update this import based on your project structure

void main() {
  group('AwardCert Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('PersonalProject.toMap should convert personal project to a map', () {
      final awardCerts = AwardCert(
          creationTimestamp: Timestamp.now(),
          acid: 'acid1',
          index: 0,
          name: 'Certification 1',
          link: 'https://example.com/user/certification',
          source: 'Example source',
          imageURL: 'https://example.com/image.jpg',
          dateIssued: Timestamp(1234567890, 0)
          );
      final awardCertMap = awardCerts.toMap();

      expect(awardCertMap['creationTimestamp'], awardCerts.creationTimestamp);
      expect(awardCertMap['acid'], 'acid1');
      expect(awardCertMap['index'], 0);
      expect(awardCertMap['name'], 'Certification 1');
      expect(awardCertMap['link'], 'https://example.com/user/certification');
      expect(awardCertMap['source'], 'Example source');
      expect(awardCertMap['imageURL'], 'https://example.com/image.jpg');
      expect(awardCertMap['dateIssued'], Timestamp(1234567890, 0));
    });

    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
