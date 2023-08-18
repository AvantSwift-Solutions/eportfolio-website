import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final Timestamp creationTimestamp;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.creationTimestamp,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final uid = data['uid'] as String;
      final email = data['email'] as String;
      final name = data['name'] as String;
      final creationTimestamp = data['creationTimestamp'] as Timestamp;

      return User(
        creationTimestamp: creationTimestamp,
        uid: uid,
        email: email,
        name: name,
      );
    } catch (e) {
      rethrow;
    }
  }
}
