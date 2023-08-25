import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  String name;
  final Timestamp creationTimestamp;
  String landingPageTitle;
  String landingPageDescription;
  String imageURL;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.creationTimestamp,
    required this.landingPageTitle,
    required this.landingPageDescription,
    required this.imageURL,
  });

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final uid = data['uid'] as String;
      final email = data['email'] as String;
      final name = data['name'] as String;
      final creationTimestamp = data['creationTimestamp'] as Timestamp;
      final landingPageTitle = data['landingPageTitle'] as String;
      final imageUrl = data['imageURL'] as String;
      final landingPageDescription = data['landingPageDescription'] as String;

      return User(
          creationTimestamp: creationTimestamp,
          uid: uid,
          email: email,
          name: name,
          landingPageTitle: landingPageTitle,
          landingPageDescription: landingPageDescription,
          imageURL: imageUrl);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'creationTimestamp': creationTimestamp,
      'landingPageTitle': landingPageTitle,
      'landingPageDescription': landingPageDescription,
      'imageUrl': imageURL
    };
  }

  Future<void> create() async {
    try {
      await FirebaseFirestore.instance.collection('User').doc(uid).set(toMap());
      print('User document created');
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  Future<bool> update() async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(uid)
          .update(toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('User').doc(uid).delete();
      print('User document deleted');
    } catch (e) {
      print('Error deleting user document: $e');
    }
  }

  static Future<User?> getFirstUser() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('User').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        return User.fromDocumentSnapshot(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
