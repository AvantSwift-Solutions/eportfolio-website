import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('User Model tests', () {
    test('fromDocumentSnapshot should return a User object', () {
      final data = {
        'uid': 'user123',
        'email': 'user@example.com',
        'name': 'John Doe',
        'creationTimestamp': Timestamp.now(),
        'nickname': 'Welcome to my page',
        'landingPageDescription': 'This is my landing page',
        'imageURL': 'https://example.com/image.jpg',
        'contactEmail': 'differentEmail@example.com',
        'linkedinURL': 'https://www.linkedin.com/in/example-user/',
        'aboutMeURL': 'https://example.com/aboutme',
        'aboutMe': 'This is about me',
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = User.fromDocumentSnapshot(snapshot);

      expect(result.uid, 'user123');
      expect(result.email, 'user@example.com');
      expect(result.name, 'John Doe');
      expect(result.creationTimestamp, data['creationTimestamp']);
      expect(result.nickname, 'Welcome to my page');
      expect(result.landingPageDescription, 'This is my landing page');
      expect(result.imageURL, 'https://example.com/image.jpg');
      expect(result.contactEmail, 'differentEmail@example.com');
      expect(result.linkedinURL, 'https://www.linkedin.com/in/example-user/');
      expect(result.aboutMeURL, 'https://example.com/aboutme');
      expect(result.aboutMe, 'This is about me');
    });

    test('User.toMap should convert user to a map', () {
      final user = User(
          uid: 'user123',
          email: 'user@example.com',
          name: 'John Doe',
          creationTimestamp: Timestamp.now(),
          nickname: 'Welcome to my page',
          landingPageDescription: 'This is my landing page',
          imageURL: 'https://example.com/image.jpg',
          contactEmail: 'differentEmail@example.com',
          linkedinURL: 'https://www.linkedin.com/in/example-user/',
          aboutMeURL: 'https://example.com/aboutme',
          aboutMe: 'This is about me');
      final userMap = user.toMap();

      expect(userMap['uid'], 'user123');
      expect(userMap['email'], 'user@example.com');
      expect(userMap['name'], 'John Doe');
      expect(userMap['nickname'], 'Welcome to my page');
      expect(userMap['landingPageDescription'], 'This is my landing page');
      expect(userMap['imageURL'], 'https://example.com/image.jpg');
      expect(userMap['contactEmail'], 'differentEmail@example.com');
      expect(
          userMap['linkedinURL'], 'https://www.linkedin.com/in/example-user/');
      expect(userMap['aboutMe'], 'This is about me');
      expect(userMap['aboutMeURL'], 'https://example.com/aboutme');
    });
    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
