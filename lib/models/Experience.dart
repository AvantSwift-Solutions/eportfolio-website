// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Experience {
  final String? peid;
  String? jobTitle;
  String? companyName;
  String? location;
  Timestamp? startDate;
  Timestamp? endDate;
  String? description;
  String? logoURL; 

  Experience({
    required this.peid,
    required this.jobTitle,
    required this.companyName,
    this.location,
    this.startDate,
    this.endDate,
    this.description,
    this.logoURL,
  });

  factory Experience.fromDocumentSnapshot(DocumentSnapshot snapshot) {
  try {
    final data = snapshot.data() as Map<String, dynamic>;
    final jobTitle = data['jobTitle'];
    final companyName = data['companyName'];
    final location = data['location'];
    final description = data['description'];
    final startDate = data['startDate'];
    final endDate = data['endDate'];
    final logoURL = data['logoURL'];

    return Experience(
      peid: snapshot.id,
      jobTitle: jobTitle,
      companyName: companyName,
      location: location,
      description: description,
      startDate: startDate,
      endDate: endDate,
      logoURL: logoURL,
    );
  } catch (e) {
    rethrow;
  }
}

  Map<String, dynamic> toMap() {
    return {
      'peid': peid,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'location': location,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'logoURL': logoURL,
    };
  }

  Future<void> create() async {
    try {
      final id = const Uuid().v4();
      await FirebaseFirestore.instance.collection('Experience').doc(id).set(toMap());
    } catch (e) {
      log('Error creating experience document: $e');
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('Experience')
          .doc(peid)
          .update(toMap());
      return true;
    } catch (e) {
      log('Error updating experience document: $e');
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('Experience').doc(peid).delete();
    } catch (e) {
      log('Error deleting experience document: $e');
    }
  }

}
