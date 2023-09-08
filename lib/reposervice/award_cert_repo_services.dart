import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/AwardCert.dart';


class AwardCertRepoService {
  Future<List<AwardCert>?> getAllAwardCert() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('AwardCert').get();
      if (snapshot.docs.isNotEmpty){
        return snapshot.docs.map((doc) => AwardCert.fromDocumentSnapshot(doc)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log('Error fetching all AwardCert: $e');
      return [];
    }
  }

}