import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/PersonalProject.dart';
import '../../reposervice/personal_project_repo_services.dart'; // Import the PersonalProject class

class PersonalProjectAdminController {
  final PersonalProjectRepoService personalProjectRepoService;

  PersonalProjectAdminController(this.personalProjectRepoService); // Constructor

  Future <List<PersonalProject>> getPersonalProjectList() async {
    try {
      List<PersonalProject> personalProjects = await personalProjectRepoService.getAllProjects();
      return personalProjects;
    } catch (e) {
      print('Error getting personal project list: $e');
      return [];
    }
  }

  
  // Future<PersonalProjectDTO?> getSelectedPersonalProject(PersonalProjectDTO personalProjectData) async {
  //   try {
  //     List<PersonalProjectDTO> personalProjectDTOList = await getPersonalProjectList();

  //     // Find the selected project by comparing with its ppid.
  //     PersonalProjectDTO? selectedProject = personalProjectDTOList.firstWhere(
  //       (project) => project.ppid == personalProjectData.ppid,
  //       // ignore: cast_from_null_always_fails
  //       orElse: () => null as PersonalProjectDTO,
  //     );

  //     return selectedProject;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<bool>? updatePersonalProjectData(int index, PersonalProject newProject) async {
    try {
      List<PersonalProject> personalProjects = await personalProjectRepoService.getAllProjects();

      personalProjects[index].name = newProject.name;
      personalProjects[index].description = newProject.description;
      personalProjects[index].imageURL = newProject.imageURL;

      bool updateSuccess = await personalProjects[index].update();
      return updateSuccess;
    } catch (e) {
      print('Error updating personal project: $e');
      return false;
    }
  }

  // Future<void> addPersonalProject(PersonalProject newProject) async {
  //   try {
  //     await newProject.create();
  //   } catch (e) {
  //     // Handle any errors, log them, and return false to indicate failure.
  //     print('Error adding personal project: $e');
  //     return;
  //   }
  // }

  Future<bool> deletePersonalProject(int index) async {
    try {
      List<PersonalProject> personalProjects = await personalProjectRepoService.getAllProjects();

      // Use the delete method or your Firestore logic to delete the project from the database.
      await personalProjects[index].delete();
      return true;
    } catch (e) {
      print('Error deleting personal project: $e');
      return false;
    }
  }



  Future<String?> uploadImageAndGetURL(
      Uint8List imageBytes, String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final imageURL = await snapshot.ref.getDownloadURL();
      return imageURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
