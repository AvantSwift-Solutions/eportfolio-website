import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avantswift_portfolio/models/Project.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('Project Model tests', () {
    test('fromDocumentSnapshot should return a Project object', () {
      final data = {
        'index': 1,
        'name': 'Test Project',
        'description': 'Test Description',
        'link': 'https://example.com',
        'creationTimestamp': Timestamp.now(),
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = Project.fromDocumentSnapshot(snapshot);

      expect(result.index, 1);
      expect(result.name, 'Test Project');
      expect(result.description, 'Test Description');
      expect(result.link, 'https://example.com');
      expect(result.creationTimestamp, data['creationTimestamp']);
    });

    test('Project.toMap should convert  project to a map', () {
      final project = Project(
        creationTimestamp: Timestamp.now(),
        ppid: 'user123',
        index: 0,
        name: 'Project 1',
        description: 'This is my project',
        link: 'https://example.com/image.jpg',
      );
      final projectMap = project.toMap();

      expect(projectMap['creationTimestamp'], project.creationTimestamp);
      expect(projectMap['ppid'], 'user123');
      expect(projectMap['index'], 0);
      expect(projectMap['name'], 'Project 1');
      expect(projectMap['description'], 'This is my project');
      expect(projectMap['link'], 'https://example.com/image.jpg');
    });
    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
