import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Project.dart';

class ProjectRepoService {
  Future<List<Project>?> getAllProjects() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Project').get();
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
}
