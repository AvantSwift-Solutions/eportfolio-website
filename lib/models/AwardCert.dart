// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class AwardCert {
  Timestamp? creationTimestamp;
  final String? acid;
  int? index;
  String? name;
  String? imageURL;
  String? link;
  String? source;
  Timestamp? dateIssued;

  AwardCert({
    required this.creationTimestamp,
    required this.acid,
    required this.index,
    required this.name,
    required this.imageURL,
    required this.link,
    required this.source,
    required this.dateIssued,
  });

  factory AwardCert.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final creationTimestamp = data['creationTimestamp'];
    final index = data['index'];
    final name = data['name'];
    final imageURL = data['imageURL'];
    final link = data['link'];
    final source = data['source'];
    final dateIssued = data['dateIssued'];

    return AwardCert(
      creationTimestamp: creationTimestamp,
      index: index,
      acid: snapshot.id,
      name: name,
      imageURL: imageURL,
      link: link,
      source: source,
      dateIssued: dateIssued,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creationTimestamp': creationTimestamp,
      'acid': acid,
      'index': index,
      'name': name,
      'imageURL': imageURL,
      'link': link,
      'source': source,
      'dateIssued': dateIssued,
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
