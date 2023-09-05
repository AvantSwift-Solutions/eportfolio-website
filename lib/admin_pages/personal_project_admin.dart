// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:avantswift_portfolio/dto/personal_project_dto.dart';
import 'package:avantswift_portfolio/reposervice/personal_project_repo_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controller/admin_controllers/personal_project_admin_controller.dart';

class PersonalProjectAdmin extends StatelessWidget {
  final PersonalProjectAdminController _adminController =
      PersonalProjectAdminController(PersonalProjectRepoService());
  PersonalProjectDTO newProject = PersonalProjectDTO(ppid: '', name: '', description: '', imageURL: '');
  PersonalProjectDTO selectedProject = PersonalProjectDTO(ppid: '', name: '', description: '', imageURL: '');
  List <PersonalProjectDTO> personalProjects = [];
  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showEditDialog(context);
              },
              child: const Text('Edit Personal Project'),
            ),
          ),
        ],
      ),
    );
  }


  void _showEditDialog(BuildContext context) async {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Edit Personal Project'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _showAddProjectDialog(context);
                  },
                  child: Text('Add Personal Project'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    _showExistingProjectsDialog(context);
                  },
                  child: Text('Update Existing Project'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
  }


  Widget _buildProjectList(BuildContext context) {
    if (personalProjects.isEmpty){
      return Text('No projects available.');
    }
    
    return ListView.builder(
      itemCount: personalProjects.length,
      itemBuilder: (context, index) {
        final project = personalProjects[index];
        return ListTile(
          key: UniqueKey(),
          title: Text(project.name),
          subtitle: Text(project.description),
          leading: Image.network(project.imageURL),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  selectedProject = project;
                  _showUpdateProjectDialog(context, selectedProject);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteDialog(context, selectedProject);
                },
              ),
            ],
          ),
          onTap: () {
            selectedProject = project;
            _showUpdateProjectDialog(context, selectedProject);
          },
        );
      },
    );
  }  



  void _showAddProjectDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    Uint8List? pickedImageBytes;

    // Implement the dialog to add a new project here.
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Personal Project'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add input fields for project details here.
                  TextField(
                    controller: nameController,
                    onChanged: (value) => newProject.name = value,
                    decoration: const InputDecoration(
                      labelText: 'Name'),
                  ),
                  TextField(
                    controller: descriptionController,
                    onChanged: (value) =>
                    newProject.description = value,
                    decoration: const InputDecoration(
                      labelText: 'Description'),
                  ),
                  if (pickedImageBytes != null)
                    Image.memory(pickedImageBytes!),
                  ElevatedButton(
                    onPressed: () async {
                      Uint8List? imageBytes = await _pickImage();
                      if (imageBytes != null) {
                        pickedImageBytes = imageBytes;
                        setState(() {});

                      }
                    },
                    child: const Text('Pick an Image'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    // Implement logic to add a new project.
                    // After adding, you can show a success message or handle errors.
                    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                      print('Name or description is empty');
                      return;
                    }
                    PersonalProjectDTO newProject = PersonalProjectDTO(
                      ppid: '',
                      name: nameController.text,
                      description: descriptionController.text,
                      imageURL: '',
                    );

                    if (pickedImageBytes != null) {
                      String? imageURL = await _adminController.uploadImageAndGetURL(
                        pickedImageBytes!,
                        'selected_image.jpg',
                      );
                      if (imageURL != null) {
                        newProject.imageURL = imageURL;
                      }
                    }

                    // Add a new project.
                    // bool isSuccess = await _adminController.addPersonalProject(newProject);
                    final ppid = await _adminController.addPersonalProject(newProject);
                    newProject.ppid = ppid!;
                    Navigator.of(dialogContext).pop();

                    if (newProject.ppid.isNotEmpty){
                      // add newProject into project list.
                      personalProjects.add(newProject);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added a new personal project')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add a new project')),
                      );
                    }
                  },
                  child: Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _showExistingProjectsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Select a Project to Update'),
          content: Container(
            width: 300,
            height: 300,
            child: _buildProjectList(context),
          ), 
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }


  void _showUpdateProjectDialog(BuildContext context, PersonalProjectDTO selectedProject) {
    // Implement the dialog to update an existing project here.
    TextEditingController nameController = TextEditingController(text: selectedProject.name);
    TextEditingController descriptionController = TextEditingController(text: selectedProject.description);
    Uint8List? pickedImageBytes;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Existing Project'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add input fields for project details here.
                  TextField(
                    controller: nameController,
                    onChanged: (value) => newProject.name = value,
                    decoration: const InputDecoration(
                      labelText: 'Name'),
                  ),
                  TextField(
                    controller: descriptionController,
                    onChanged: (value) =>
                    newProject.description = value,
                    decoration: const InputDecoration(
                      labelText: 'Description'),
                  ),
                  if (pickedImageBytes != null)
                    Image.memory(pickedImageBytes!),
                  ElevatedButton(
                    onPressed: () async {
                      Uint8List? imageBytes = await _pickImage();
                      if (imageBytes != null) {
                        pickedImageBytes = imageBytes;
                        setState(() {});
                      }
                    },
                    child: const Text('Pick an Image'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    // Implement logic to update an existing project.
                    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                      print('Name or description is empty');
                      return;
                    }
                    // If the user picked a new image, upload it and update the imageURL.
                    if (pickedImageBytes != null) {
                      String? imageURL = await _adminController.uploadImageAndGetURL(
                        pickedImageBytes!,
                        'selected_image.jpg',
                      );
                      if (imageURL != null) {
                        selectedProject.imageURL = imageURL;
                      }
                    }

                    bool? isSuccess = await _adminController.updatePersonalProjectData(selectedProject);
                    if (isSuccess != null) {
                      if (isSuccess) {
                        int index = personalProjects.indexWhere((project) => project.ppid == selectedProject.ppid);
                        if (index != -1) {
                          setState(() {
                            personalProjects[index] = selectedProject;
                          });
                        }
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Updated an existing personal project')),
                        );
                        // setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update an existing personal project')),
                        );
                      }
                    }
                  },
                  child: Text('Update'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _showDeleteDialog(BuildContext context, PersonalProjectDTO selectedProject) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete this project?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Call the deletePersonalProject method here.
                    final deleted = await _adminController.deletePersonalProject(selectedProject);
                    Navigator.of(dialogContext).pop(); // Close the dialog.
                    if (deleted) {
                      // Remove the deleted project from the personalProjects list.
                      personalProjects.removeWhere((project) => project.ppid == selectedProject.ppid);
                      // Update the UI if needed.
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Project deleted successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete the project')),
                      );
                    }
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Future<Uint8List?> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.single;
      Uint8List imageBytes = pickedFile.bytes!;
      return imageBytes;
    }

    return null;
  }
}

