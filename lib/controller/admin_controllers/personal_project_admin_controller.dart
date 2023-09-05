import 'dart:typed_data';
import 'package:avantswift_portfolio/dto/personal_project_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/PersonalProject.dart';
import '../../reposervice/personal_project_repo_services.dart'; // Import the User class

class PersonalProjectAdminController {
  final PersonalProjectRepoService personalProjectRepoService;

  PersonalProjectAdminController(this.personalProjectRepoService); // Constructor

  Future <List<PersonalProjectDTO>> getPersonalProjectList() async {
    try {
      List<PersonalProject?>? personalProjectList = await personalProjectRepoService.getAllProjects();
      List<PersonalProjectDTO> personalProjectDTOList = [];

      for (PersonalProject? project in personalProjectList) {
        if (project != null) {
          personalProjectDTOList.add(
            PersonalProjectDTO(
              ppid: project.ppid ?? 'Unknown',
              name: project.name ?? 'Unknown',
              description: project.description ?? 'No description',
              imageURL: project.imageURL ?? 'https://example.com/default_image.jpg',
            ),
          );
        }
      }
      
      return personalProjectDTOList;
    } catch (e) {
      print('Error getting personal project list: $e');
      return [];
    }
  }

  
  Future<PersonalProjectDTO?> getSelectedPersonalProject(PersonalProjectDTO personalProjectData) async {
    try {
      List<PersonalProjectDTO> personalProjectDTOList = await getPersonalProjectList();

      // Find the selected project by comparing with its ppid.
      PersonalProjectDTO? selectedProject = personalProjectDTOList.firstWhere(
        (project) => project.ppid == personalProjectData.ppid,
        // ignore: cast_from_null_always_fails
        orElse: () => null as PersonalProjectDTO,
      );

      return selectedProject;
    } catch (e) {
      return null;
    }
  }

  Future<bool>? updatePersonalProjectData(PersonalProjectDTO personalProjectData) async {
    try {
      // List<PersonalProject?>? personalProjectList = await personalProjectRepoService.getAllProjects();
      PersonalProject? projectToUpdate = await personalProjectRepoService.getSelectedProject(personalProjectData);

      if (projectToUpdate != null) {
        projectToUpdate.name = personalProjectData.name;
        projectToUpdate.description = personalProjectData.description;
        projectToUpdate.imageURL = personalProjectData.imageURL;
        // final imageURL = await uploadImageAndGetURL(imageBytes, fileName);
        final updatedProject = await projectToUpdate.update() ?? false;
        bool updateSuccess = updatedProject != null ;
        print('update successful');
        // print(projectToUpdate.ppid);
        return updateSuccess;
      } else {
        print('project not found');
        return false;
      }
    } catch (e) {
      print('Error updating personal project: $e');
      return false;
    }
  }

  Future<String?> addPersonalProject(PersonalProjectDTO newProjectData) async {
    try {
      // PersonalProject? mostRecentProject = await personalProjectRepoService.getMostRecentlyCreatedProject();
      
      // Create a PersonalProject instance from the DTO data.
      PersonalProject newProject = PersonalProject(
        ppid: newProjectData.ppid, 
        name: newProjectData.name,
        description: newProjectData.description,
        creationTimestamp: Timestamp.now(), // Set the creation timestamp as appropriate.
        imageURL: newProjectData.imageURL,
      );

      // Use the create method or your Firestore logic to add the project to the database.
      final ppid = await newProject.create();
      newProject.ppid = ppid;
      print('new project added');
      print(newProject.ppid);
      return newProject.ppid; // Return true to indicate success.
    } catch (e) {
      // Handle any errors, log them, and return false to indicate failure.
      print('Error adding personal project: $e');
      return null;
    }
  }

  Future<bool> deletePersonalProject(PersonalProjectDTO selectedProject) async {
    try {
      // Find the project to delete by ppid.
      PersonalProject? projectToDelete = await personalProjectRepoService.getSelectedProject(selectedProject);

      if (projectToDelete != null) {
        // Use the delete method or your Firestore logic to delete the project from the database.
        await projectToDelete.delete();
        print('Project deleted');
        return true;
      } else {
        print('Project not found for deletion');
        return false;
      }
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
