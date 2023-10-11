import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import '../models/AboutAss.dart';

class AboutAssRepoService {
  Future<List<AboutAss>?> getAllAboutAss() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('AboutAss')
          .orderBy('index')
          .get();
      final tmp = snapshot.docs
          .map((doc) => AboutAss.fromDocumentSnapshot(doc))
          .toList();
      return tmp;
    } catch (e) {
      log('Error getting all About Ass: $e');
      return null;
    }
  }
}
