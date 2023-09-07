import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/PersonalProject.dart';
import '../../reposervice/personal_project_repo_services.dart'; // Import the PersonalProject class

class PersonalProjectAdminController {
  final PersonalProjectRepoService personalProjectRepoService;

  PersonalProjectAdminController(this.personalProjectRepoService); // Constructor

  Future <List<PersonalProject>?> getPersonalProjectList() async {
    try {
      List<PersonalProject>? personalProjects = await personalProjectRepoService.getAllProjects();
      return personalProjects;
    } catch (e) {
      print('Error getting personal project list: $e');
      return null;
    }
  }

  
  Future<bool>? updatePersonalProjectData(int index, PersonalProject newProject) async {
    try {
      List<PersonalProject>? personalProjects = await personalProjectRepoService.getAllProjects();

      personalProjects?[index].name = newProject.name;
      personalProjects?[index].description = newProject.description;
      personalProjects?[index].imageURL = newProject.imageURL;

      bool? updateSuccess = await personalProjects?[index].update() ?? false;
      return updateSuccess;
    } catch (e) {
      print('Error updating personal project: $e');
      return false;
    }
  }


  Future<bool> deletePersonalProject(int index) async {
    try {
      List<PersonalProject>? personalProjects = await personalProjectRepoService.getAllProjects();
      await personalProjects?[index].delete();
      return true;
    } catch (e) {
      print('Error deleting personal project: $e');
      return false;
    }
  }



  Future<String?> uploadImageAndGetURL(Uint8List imageBytes, String fileName) async {
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
