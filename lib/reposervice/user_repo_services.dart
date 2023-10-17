import 'dart:developer';

import 'package:avantswift_portfolio/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/User.dart';

class UserRepoService {
  Future<User?> getFirstUser() async {
    try {
      DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection('User')
          .doc(Constants.uid)
          .get();
      if (docUser.exists) {
        return User.fromDocumentSnapshot(docUser);
      } else {
        return null;
      }
    } catch (e) {
      log('Error getting first user: $e');
      return null;
    }
  }
}
