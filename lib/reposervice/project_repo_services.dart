import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Project.dart';

class ProjectRepoService {
  Future<List<Project>?> getAllProjects() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Project')
          .orderBy('index')
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => Project.fromDocumentSnapshot(doc))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      log('Error getting all projects: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getDocumentById(String documentId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Project')
          .doc(documentId)
          .get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting document by ID: $e');
      return null;
    }
  }

  Future<void> updateDocumentField(
      String documentId, String fieldName, dynamic newValue) async {
    try {
      await FirebaseFirestore.instance
          .collection('Project')
          .doc(documentId)
          .update({fieldName: newValue});
    } catch (e) {
      log('Error updating field: $e');
    }
  }
}
