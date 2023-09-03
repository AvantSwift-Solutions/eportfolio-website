import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Education.dart';

class EducationRepoService {
  Future<List<Education>?> getAllEducation() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Education').get();
      final tmp = snapshot.docs
          .map((doc) => Education.fromDocumentSnapshot(doc))
          .toList();  
      return tmp;
    } catch (e) {
      log('error: $e');  
      return null;
    }
  }
}