import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ISkill.dart';

class ISkillRepoService {
  Future<List<ISkill>?> getAllISkill() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('ISkill').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => ISkill.fromDocumentSnapshot(doc))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting all ISkill: $e');
      return null;
    }
  }
}
