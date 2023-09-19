// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  Timestamp? creationTimestamp;
  final String? eid;
  int? index;
  Timestamp? startDate;
  Timestamp? endDate;
  String? logoURL;
  String? schoolName;
  String? degree;
  String? description;
  String? major;
  double? grade;
  String? gradeDescription;

  Education({
    required this.creationTimestamp,
    required this.eid,
    required this.index,
    required this.startDate,
    required this.endDate,
    required this.logoURL,
    required this.schoolName,
    required this.degree,
    required this.description,
    required this.major,
    required this.grade,
    required this.gradeDescription,
  });

  factory Education.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final creationTimestamp = data['creationTimestamp'];
    final index = data['index'];
    final startDate = data['startDate'];
    final endDate = data['endDate'];
    final logoURL = data['logoURL'];
    final schoolName = data['schoolName'];
    final degree = data['degree'];
    final description = data['description'];
    final major = data['major'];
    final grade = data['grade'];
    final gradeDescription = data['gradeDescription'];

    return Education(
      creationTimestamp: creationTimestamp,
      eid: snapshot.id,
      index: index,
      startDate: startDate,
      endDate: endDate,
      logoURL: logoURL,
      schoolName: schoolName,
      degree: degree,
      description: description,
      major: major,
      grade: grade,
      gradeDescription: gradeDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eid': eid,
      'creationTimestamp': creationTimestamp,
      'index': index,
      'startDate': startDate,
      'endDate': endDate,
      'logoURL': logoURL,
      'schoolName': schoolName,
      'degree': degree,
      'description': description,
      'major': major,
      'grade': grade,
      'gradeDescription': gradeDescription,
    };
  }

  Future<bool> create(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Education')
          .doc(eid)
          .set(toMap());
      return true;
    } catch (e) {
      log('Error creating education document: $e');
      return false;
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('Education')
          .doc(eid)
          .update(toMap());
      return true;
    } catch (e) {
      log('Error updating education document: $e');
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('Education')
          .doc(eid)
          .delete();
      return true;
    } catch (e) {
      log('Error deleting education document: $e');
      return false;
    }
  }
}
