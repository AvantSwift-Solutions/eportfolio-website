import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import '../models/Reccomendation.dart';

class ReccomendationRepoService {
  Future<List<Reccomendation>?> getAllReccomendations() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Reccomendation').get();
      final tmp = snapshot.docs
          .map((doc) => Reccomendation.fromDocumentSnapshot(doc))
          .toList();  
      return tmp;
    } catch (e) {
      log('error: $e');  
      return null;
    }
  }
}
