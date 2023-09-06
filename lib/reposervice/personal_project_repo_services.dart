import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/PersonalProject.dart';


class PersonalProjectRepoService {
  Future<List<PersonalProject>> getAllProjects() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('PersonalProject').get();
      if (snapshot.docs.isNotEmpty){
        return snapshot.docs.map((doc) => PersonalProject.fromDocumentSnapshot(doc)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching all projects: $e');
      return [];
    }
  }

}