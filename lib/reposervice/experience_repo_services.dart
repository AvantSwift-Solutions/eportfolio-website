import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import '../models/Experience.dart';

class ExperienceRepoService {
  Future<List<Experience>?> getAllExperiences() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Experience')
          .orderBy('index')
          .get();
      final tmp = snapshot.docs
          .map((doc) => Experience.fromDocumentSnapshot(doc))
          .toList();
      return tmp;
    } catch (e) {
      log('Error getting all experiences: $e');
      return null;
    }
  }
}
