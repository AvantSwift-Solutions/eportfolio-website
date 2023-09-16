import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/Project.dart';
import '../../reposervice/project_repo_services.dart'; // Import the Project class

class ProjectSectionAdminController {
  final ProjectRepoService projectRepoService;

  ProjectSectionAdminController(this.projectRepoService); // Constructor

  Future<List<Project>?> getProjectList() async {
    try {
      List<Project>? projects = await projectRepoService.getAllProjects();
      return projects;
    } catch (e) {
      log('Error getting  project list: $e');
      return null;
    }
  }

  Future<bool>? updateProjectData(int index, Project newProject) async {
    try {
      List<Project>? projects = await projectRepoService.getAllProjects();

      projects?[index].name = newProject.name;
      projects?[index].description = newProject.description;
      projects?[index].link = newProject.link;

      bool? updateSuccess = await projects?[index].update() ?? false;
      return updateSuccess;
    } catch (e) {
      log('Error updating  project: $e');
      return false;
    }
  }

  Future<bool> deleteProject(int index) async {
    try {
      List<Project>? projects = await projectRepoService.getAllProjects();
      await projects?[index].delete();
      return true;
    } catch (e) {
      log('Error deleting  project: $e');
      return false;
    }
  }

  // Future<String?> uploadImageAndGetURL(
  //     Uint8List imageBytes, String fileName) async {
  //   try {
  //     final ref = FirebaseStorage.instance.ref().child('images/$fileName');
  //     final uploadTask = ref.putData(imageBytes);
  //     final TaskSnapshot snapshot = await uploadTask;
  //     final imageURL = await snapshot.ref.getDownloadURL();
  //     return imageURL;
  //   } catch (e) {
  //     log('Error uploading image: $e');
  //     return null;
  //   }
  // }
}
