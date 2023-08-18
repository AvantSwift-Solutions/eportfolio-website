import 'package:avantswift_portfolio/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('User', () {
    late DocumentSnapshot snapshot;

    setUp(() {
      final data = {
        'uid': '123',
        'email': 'test@example.com',
        'name': 'Test User',
        'creationTimestamp': Timestamp.now(),
      };
      snapshot = MockDocumentSnapshot(data);
    });

    test('Can be created from a document snapshot', () {
      final user = User.fromDocumentSnapshot(snapshot);

      expect(user.uid, equals('123'));
      expect(user.email, equals('test@example.com'));
      expect(user.name, equals('Test User'));
      expect(user.creationTimestamp, isA<Timestamp>());
    });

    test('Throws an error if the document snapshot is missing required fields',
        () {
      final data = {
        'uid': '123',
        'email': 'test@example.com',
        'creationTimestamp': Timestamp.now(),
      };
      snapshot = MockDocumentSnapshot(data);

      expect(() => User.fromDocumentSnapshot(snapshot), throwsException);
    });
  });
}

// ignore: subtype_of_sealed_class
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> _data;

  MockDocumentSnapshot(this._data);

  @override
  dynamic operator [](Object? key) => _data[key];

  Map<String, dynamic> get mockData => _data;
}
