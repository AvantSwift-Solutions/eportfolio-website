import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/TSkill.dart';

class TSkillRepoService {
  Future<List<TSkill>?> getAllTSkill() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('TSkill').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => TSkill.fromDocumentSnapshot(doc))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting all TSkill: $e');
      return null;
    }
  }
}
