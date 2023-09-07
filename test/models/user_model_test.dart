import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:avantswift_portfolio/models/User.dart';

void main() {
  group('User class tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('User.toMap should convert user to a map', () {
      final user = User(
          uid: 'user123',
          email: 'user@example.com',
          name: 'John Doe',
          creationTimestamp: Timestamp.now(),
          landingPageTitle: 'Welcome to my page',
          landingPageDescription: 'This is my landing page',
          imageURL: 'https://example.com/image.jpg',
          contactEmail: 'differentEmail@example.com',
          linkedinURL: 'https://www.linkedin.com/in/example-user/',
          aboutMe: 'This is about me');
      final userMap = user.toMap();

      expect(userMap['uid'], 'user123');
      expect(userMap['email'], 'user@example.com');
      expect(userMap['name'], 'John Doe');
      expect(userMap['landingPageTitle'], 'Welcome to my page');
      expect(userMap['landingPageDescription'], 'This is my landing page');
      expect(userMap['imageURL'], 'https://example.com/image.jpg');
      expect(userMap['contactEmail'], 'differentEmail@example.com');
      expect(
          userMap['linkedinURL'], 'https://www.linkedin.com/in/example-user/');
      expect(userMap['aboutMe'], 'This is about me');
    });

    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
