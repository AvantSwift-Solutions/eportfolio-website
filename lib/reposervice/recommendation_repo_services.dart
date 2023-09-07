import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import '../models/Recommendation.dart';

class RecommendationRepoService {
  Future<List<Recommendation>?> getAllRecommendations() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Recommendation').get();
      final tmp = snapshot.docs
          .map((doc) => Recommendation.fromDocumentSnapshot(doc))
          .toList();  
      return tmp;
    } catch (e) {
      log('error: $e');  
      return null;
    }
  }
}
