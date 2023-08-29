import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/User.dart';

class UserRepoService {
  Future<User?> getFirstUser() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('User').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        return User.fromDocumentSnapshot(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
