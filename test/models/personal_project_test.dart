import 'package:flutter_test/flutter_test.dart';

import 'package:avantswift_portfolio/models/PersonalProject.dart'; // Update this import based on your project structure

void main() {
  group('PersonalProject class tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('PersonalProject.toMap should convert personal project to a map', () {
      final personalProject = PersonalProject(
        ppid: 'user123',
        name: 'Project 1',
        description: 'This is my project',
        imageURL: 'https://example.com/image.jpg',
      );
      final personalProjectMap = personalProject.toMap();

      expect(personalProjectMap['ppid'], 'user123');
      expect(personalProjectMap['name'], 'Project 1');

      // Add more assertions for other properties
    });

    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
