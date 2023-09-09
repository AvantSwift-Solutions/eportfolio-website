// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class AwardCert {
  final String? acid;
  String? name;
  String? imageURL;
  String? link;
  String? source;
  Timestamp? creationTimestamp;

  AwardCert({
    required this.acid,
    required this.name,
    this.imageURL,
    required this.link,
    required this.source,
    this.creationTimestamp,
  });

  factory AwardCert.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final name = data['name'];
    final imageURL = data['imageURL'];
    final link = data['link'];
    final source = data['source'];
    final creationTimestamp = data['creationTimestamp'];

    return AwardCert(
      acid: snapshot.id,
      name: name,
      imageURL: imageURL,
      link: link,
      source: source,
      creationTimestamp: creationTimestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'acid': acid,
      'name': name,
      'imageURL': imageURL,
      'link': link,
      'source': source,
      'creationTimestamp': creationTimestamp,
    };
  }

  Future<bool> create(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('AwardCert')
          .doc(id)
          .set(toMap());
      return true;
    } catch (e) {
      log('Error creating AwardCert document: $e');
      return false;
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('AwardCert')
          .doc(acid)
          .update(toMap());
      return true;
    } catch (e) {
      log('Error updating AwardCert document: $e');
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('AwardCert')
          .doc(acid)
          .delete();
      return true;
    } catch (e) {
      log('Error deleting AwardCert document: $e');
      return false;
    }
  }
}
