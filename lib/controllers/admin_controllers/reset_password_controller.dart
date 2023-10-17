import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordController {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('User');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> sendPasswordResetToMostRecentEmail(String email) async {
  try {
    final user = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    
    if (user.isNotEmpty) {
      // The email is associated with an authenticated user.
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      log('Password reset email sent to $email');
    } else {
      // The email is not associated with any user.
      log('No user found with the email $email');
      // You can handle this case as per your application's requirements.
    }
  } catch (e) {
    log('Error sending password reset email: $e');
    // You can handle the error as needed.
  }
    return true; // Have to return true to automatically close dialog upon pressing send
  }

}
