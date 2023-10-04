import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avantswift_portfolio/models/Education.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('Education Model tests', () {
    test('fromDocumentSnapshot should return an Education object', () {
      final data = {
        'creationTimestamp': Timestamp.now(),
        'index': 1,
        'startDate': Timestamp.now(),
        'endDate': Timestamp.now(),
        'logoURL': 'https://example.com/logo.jpg',
        'schoolName': 'Test School',
        'degree': 'Test Degree',
        'description': 'Test Description',
        'major': 'Test Major',
        'grade': 4.0,
        'gradeDescription': 'Test Grade Description',
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = Education.fromDocumentSnapshot(snapshot);

      expect(result.creationTimestamp, data['creationTimestamp']);
      expect(result.index, 1);
      expect(result.startDate, data['startDate']);
      expect(result.endDate, data['endDate']);
      expect(result.logoURL, 'https://example.com/logo.jpg');
      expect(result.schoolName, 'Test School');
      expect(result.degree, 'Test Degree');
      expect(result.description, 'Test Description');
      expect(result.major, 'Test Major');
      expect(result.grade, 4.0);
      expect(result.gradeDescription, 'Test Grade Description');
    });

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
