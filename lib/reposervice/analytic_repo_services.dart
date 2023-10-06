import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Analytic.dart';

class AnalyticRepoService {
  Future<Analytic?> getAnalytic() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Analytic')
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return Analytic.fromDocumentSnapshot(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting analytic: $e');
      return null;
    }
  }
}
