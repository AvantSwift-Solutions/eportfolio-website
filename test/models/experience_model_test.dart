import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avantswift_portfolio/models/Experience.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('Experience Model tests', () {
    test('fromDocumentSnapshot should return an Experience object', () {
      final data = {
        'creationTimestamp': Timestamp.now(),
        'peid': '123',
        'index': 1,
        'jobTitle': 'Test Job Title',
        'employmentType': 'Test Employment Type',
        'companyName': 'Test Company',
        'location': 'Test Location',
        'description': 'Test Description',
        'startDate': Timestamp.now(),
        'endDate': Timestamp.now(),
        'logoURL': 'https://example.com/logo.jpg',
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = Experience.fromDocumentSnapshot(snapshot);

      expect(result.creationTimestamp, data['creationTimestamp']);
      expect(result.peid, '123');
      expect(result.index, 1);
      expect(result.jobTitle, 'Test Job Title');
      expect(result.employmentType, 'Test Employment Type');
      expect(result.companyName, 'Test Company');
      expect(result.location, 'Test Location');
      expect(result.description, 'Test Description');
      expect(result.startDate, data['startDate']);
      expect(result.endDate, data['endDate']);
      expect(result.logoURL, 'https://example.com/logo.jpg');
    });

    test('Experience.toMap should convert Experience to a map', () {
      final experience = Experience(
        creationTimestamp: Timestamp.now(),
        peid: 'exp123',
        index: 1,
        jobTitle: 'Scrum Master',
        employmentType: 'Full Time',
        companyName: 'TikTok',
        location: 'New York',
        startDate: Timestamp(1234567890, 0),
        endDate: Timestamp(1234567890, 0),
        logoURL: 'https://example.com/image.jpg',
        description: 'This is my job',
      );
      final experienceMap = experience.toMap();

      expect(experienceMap['creationTimestamp'], experience.creationTimestamp);
      expect(experienceMap['peid'], 'exp123');
      expect(experienceMap['index'], 1);
      expect(experienceMap['jobTitle'], 'Scrum Master');
      expect(experienceMap['employmentType'], 'Full Time');
      expect(experienceMap['companyName'], 'TikTok');
      expect(experienceMap['location'], 'New York');
      expect(experienceMap['startDate'], Timestamp(1234567890, 0));
      expect(experienceMap['endDate'], Timestamp(1234567890, 0));
      expect(experienceMap['logoURL'], 'https://example.com/image.jpg');
      expect(experienceMap['description'], 'This is my job');
    });
  });
}
