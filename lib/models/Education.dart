// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Education {
  final String? eid;
  Timestamp? startDate;
  Timestamp? endDate;
  String? logoURL;
  String? schoolName;
  String? degree;
  String? description;
  String? gradeDescription;
  int? index;
  int? grade;
  String? major;

  Education({
    required this.eid,
    required this.startDate,
    required this.endDate,
    this.logoURL,
    required this.schoolName,
    required this.degree,
    this.description,
    this.gradeDescription,
    this.grade,
    this.index,
    this.major,
  });

  factory Education.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final startDate = data['startDate'];
    final endDate = data['endDate'];
    final logoURL = data['logoURL'];
    final schoolName = data['schoolName'];
    final degree = data['degree'];
    final description = data['description'];
    final gradeDescription = data['gradeDescription'];
    final grade = data['grade'];
    final index = data['index'];
    final major = data['major'];

    return Education(
      eid: snapshot.id,
      startDate: startDate,
      endDate: endDate,
      logoURL: logoURL,
      schoolName: schoolName,
      degree: degree,
      description: description,
      gradeDescription: gradeDescription,
      grade: grade,
      index: index,
      major: major,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eid': eid,
      'startDate': startDate,
      'endDate': endDate,
      'logoURL': logoURL,
      'schoolName': schoolName,
      'degree': degree,
      'description': description,
      'gradeDescription': gradeDescription,
      'grade': grade,
      'index': index,
      'major': major,
    };
  }

  Future<void> create() async {
    try {
      final eid = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection('Education')
          .doc(eid)
          .set(toMap());
    } catch (e) {
      log('Error creating education document: $e');
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

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('Education')
          .doc(eid)
          .delete();
    } catch (e) {
      log('Error deleting education document: $e');
    }
  }
}
