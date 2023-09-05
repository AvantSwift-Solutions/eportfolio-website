import 'package:avantswift_portfolio/dto/personal_project_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/PersonalProject.dart';


class PersonalProjectRepoService {
  Future<List<PersonalProject>> getAllProjects() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('PersonalProject').get();
      final allData = snapshot.docs.map((doc) => PersonalProject.fromDocumentSnapshot(doc)).toList();
      return allData;
    } catch (e) {
      print('Error fetching all projects: $e');
      return [];
    }
  }

  Future<PersonalProject?> getSelectedProject(PersonalProjectDTO selectedProject) async {
    try {
      if (selectedProject.ppid.isEmpty){
        print('ppid is empty');
        return null;
      }
      DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('PersonalProject')
          .doc(selectedProject.ppid)
          .get();

      if (querySnapshot.exists) {
        String docID = querySnapshot.id;
        PersonalProject project = PersonalProject.fromDocumentSnapshot(querySnapshot);
        project.ppid = docID;
        return project;
      } else {
        // No projects found.
        return null;
      }
    } catch (e) {
      // Handle any errors.
      print('Error fetching most recently created project: $e');
      return null;
    }
  }
}