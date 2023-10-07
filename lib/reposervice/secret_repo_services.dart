import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Secret.dart';

class SecretRepoService {
  Future<Secret?>? getSecret() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Secret').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        return Secret.fromDocumentSnapshot(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting secret: $e');
      return null;
    }
  }
}
