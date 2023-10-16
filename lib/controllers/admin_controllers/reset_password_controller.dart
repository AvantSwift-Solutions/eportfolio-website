import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordController {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> sendPasswordResetToMostRecentEmail(String givenEmail) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .orderBy('creationTimestamp', descending: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty ) {
        String userEmail = querySnapshot.docs[0]['email'];
         if (userEmail == givenEmail) {
          // Send password reset email using Firebase Auth
          await _auth.sendPasswordResetEmail(email: userEmail);
         }
         return true;
      }
      return false; // No user found in the collection
    } catch (e) {
      log("Error sending password reset email: $e");
      return false; // Email sending failed
    }
  }
}
