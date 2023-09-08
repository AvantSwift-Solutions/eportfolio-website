import 'package:flutter_test/flutter_test.dart';

import 'package:avantswift_portfolio/models/Project.dart'; // Update this import based on your project structure

void main() {
  group('Project class tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('Project.toMap should convert  project to a map', () {
      final project = Project(
        ppid: 'user123',
        name: 'Project 1',
        description: 'This is my project',
        imageURL: 'https://example.com/image.jpg',
      );
      final projectMap = project.toMap();

      expect(projectMap['ppid'], 'user123');
      expect(projectMap['name'], 'Project 1');

      // Add more assertions for other properties
    });

    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
