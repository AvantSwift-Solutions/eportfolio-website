import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Education.dart';

class EducationRepoService {
  Future<List<Education>?> getAllEducation() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Education')
          .orderBy('index')
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => Education.fromDocumentSnapshot(doc))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting all education: $e');
      return null;
    }
  }
}
