import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? uid;
  final String? email;
  String? name;
  final Timestamp? creationTimestamp;
  String? nickname;
  String? landingPageDescription;
  String? imageURL;
  String? contactEmail;
  String? linkedinURL;
  String? aboutMe;

  User(
      {required this.uid,
      required this.email,
      required this.name,
      required this.creationTimestamp,
      required this.nickname,
      required this.landingPageDescription,
      required this.imageURL,
      required this.contactEmail,
      required this.linkedinURL,
      required this.aboutMe});

  factory User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final uid = data['uid'] as String;
      final email = data['email'] as String;
      final name = data['name'] as String;
      final creationTimestamp = data['creationTimestamp'] as Timestamp;
      final nickname = data['nickname'] as String;
      final imageUrl = data['imageURL'] as String;
      final landingPageDescription = data['landingPageDescription'] as String;
      final contactEmail = data['contactEmail'] as String;
      final linkedinURL = data['linkedinURL'] as String;
      final aboutMe = data['aboutMe'] as String;

      return User(
          creationTimestamp: creationTimestamp,
          uid: uid,
          email: email,
          name: name,
          nickname: nickname,
          landingPageDescription: landingPageDescription,
          imageURL: imageUrl,
          contactEmail: contactEmail,
          linkedinURL: linkedinURL,
          aboutMe: aboutMe);
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
      'nickname': nickname,
      'landingPageDescription': landingPageDescription,
      'imageURL': imageURL,
      'contactEmail': contactEmail,
      'linkedinURL': linkedinURL,
      'aboutMe': aboutMe
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

  Future<bool>? update() async {
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
}
