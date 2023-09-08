import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/Project.dart';
import '../../reposervice/project_repo_services.dart'; // Import the Project class

class ProjectSectionAdminController {
  final ProjectRepoService projectRepoService;

  ProjectSectionAdminController(this.projectRepoService); // Constructor

  Future <List<Project>?> getProjectList() async {
    try {
      List<Project>? Projects = await projectRepoService.getAllProjects();
      return Projects;
    } catch (e) {
      print('Error getting  project list: $e');
      return null;
    }
  }

  
  Future<bool>? updateProjectData(int index, Project newProject) async {
    try {
      List<Project>? Projects = await projectRepoService.getAllProjects();

      Projects?[index].name = newProject.name;
      Projects?[index].description = newProject.description;
      Projects?[index].imageURL = newProject.imageURL;

      bool? updateSuccess = await Projects?[index].update() ?? false;
      return updateSuccess;
    } catch (e) {
      print('Error updating  project: $e');
      return false;
    }
  }


  Future<bool> deleteProject(int index) async {
    try {
      List<Project>? Projects = await projectRepoService.getAllProjects();
      await Projects?[index].delete();
      return true;
    } catch (e) {
      print('Error deleting  project: $e');
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
