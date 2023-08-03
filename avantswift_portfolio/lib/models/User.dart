import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String name;

  User({
    required this.uid,
    required this.email,
    required this.name,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final uid = data['uid'] as String;
      final email = data['email'] as String;
      final name = data['name'] as String;

      return User(
        uid: uid,
        email: email,
        name: name,
      );
    } catch (e) {
      rethrow;
    }
  }
}
