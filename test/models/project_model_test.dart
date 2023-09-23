import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:avantswift_portfolio/models/Project.dart'; // Update this import based on your project structure

void main() {
  group('Project Model tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

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
