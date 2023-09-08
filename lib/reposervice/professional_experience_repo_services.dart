import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import '../models/ProfessionalExperience.dart';

class ProfessionalExperienceRepoService {
  Future<List<ProfessionalExperience>?> getAllProfessionalExperiences() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('ProfessionalExperience').get();
      final tmp = snapshot.docs
          .map((doc) => ProfessionalExperience.fromDocumentSnapshot(doc))
          .toList();  
      return tmp;
    } catch (e) {
      log('error: $e');  
      return null;
    }
  }
}
