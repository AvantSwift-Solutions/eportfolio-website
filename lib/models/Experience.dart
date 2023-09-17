// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {
  Timestamp? creationTimestamp;
  final String? peid;
  int? index;
  String? jobTitle;
  String? employmentType;
  String? companyName;
  String? location;
  Timestamp? startDate;
  Timestamp? endDate;
  String? description;
  String? logoURL;

  Experience({
    required this.creationTimestamp,
    required this.peid,
    required this.index,
    required this.jobTitle,
    required this.companyName,
    required this.employmentType,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.logoURL,
  });

  factory Experience.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final creationTimestamp = data['creationTimestamp'];
      final index = data['index'];
      final jobTitle = data['jobTitle'];
      final employmentType = data['employmentType'];
      final companyName = data['companyName'];
      final location = data['location'];
      final description = data['description'];
      final startDate = data['startDate'];
      final endDate = data['endDate'];
      final logoURL = data['logoURL'];

      return Experience(
        creationTimestamp: creationTimestamp,
        peid: snapshot.id,
        index: index,
        jobTitle: jobTitle,
        employmentType: employmentType,
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
      'creationTimestamp': creationTimestamp,
      'peid': peid,
      'index': index,
      'jobTitle': jobTitle,
      'employmentType': employmentType,
      'companyName': companyName,
      'location': location,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'logoURL': logoURL,
    };
  }

  Future<bool> create(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Experience')
          .doc(id)
          .set(toMap());
      return true;
    } catch (e) {
      log('Error creating experience document: $e');
      return false;
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

  Future<bool> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('Experience')
          .doc(peid)
          .delete();
      return true;
    } catch (e) {
      log('Error deleting experience document: $e');
      return false;
    }
  }
}
