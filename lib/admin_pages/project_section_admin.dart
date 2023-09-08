// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:developer';
import 'dart:typed_data';
import 'package:avantswift_portfolio/reposervice/project_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controllers/admin_controllers/project_section_admin_controller.dart';
import '../models/Project.dart';

class ProjectSectionAdmin extends StatelessWidget {
  final ProjectSectionAdminController _adminController =
      ProjectSectionAdminController(ProjectRepoService());

  ProjectSectionAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                _showEditDialog(context, await _adminController.getProjectList());
              },
              child: const Text('Edit  Project'),
            ),
          ),
        ],
      ),
    );
  }


  void _showEditDialog(BuildContext context, List<Project>? projects) async {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Edit  Project'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: ()  {
                    Navigator.of(dialogContext).pop();
                    _showAddProjectDialog(context, projects!);
                  },
                  child: const Text('Add  Project'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    _showExistingProjectsDialog(context, projects!);
                  },
                  child: const Text('Update Existing Project'),
                ),
              ],
            ),
            actions: <Widget>[
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
  }


  void _showAddProjectDialog(BuildContext context, List<Project> projects) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    Uint8List? pickedImageBytes;
    Project newProject = Project(ppid: '', name: '', creationTimestamp: Timestamp.now());

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add  Project'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                      log('Name or description is empty');
                      return;
                    }
                    
                    if (pickedImageBytes != null) {
                      String? imageURL = await _adminController.uploadImageAndGetURL(
                        pickedImageBytes!,
                        'selected_image.jpg',
                      );
                      if (imageURL != null) {
                        newProject.imageURL = imageURL;
                      }
                    }

                    // await _adminController.addProject(newProject);
                    newProject.create();
                    projects.add(newProject);
                    Navigator.of(dialogContext).pop();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added a new  project')),
                    );
                  },
                  child: const Text('Add'),
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


  void _showExistingProjectsDialog(BuildContext context, List<Project> projects) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Project List'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: projects.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(projects[index].name!),
                        // subtitle: Text(Projects[index].description),
                        // leading: Image.network(Projects[index].imageURL),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showUpdateProjectDialog(context, index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteDialog(context, index);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _showUpdateProjectDialog(context, index);
                        },
                      );
                    },
                  )
                : const Text('No projects available'),
          ), 
          actions: <Widget>[
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
  }


  void _showUpdateProjectDialog(BuildContext context, int i) async {
    final projects = await _adminController.getProjectList();
    final selectedProject = projects?[i];

    TextEditingController nameController = TextEditingController(text: selectedProject?.name);
    TextEditingController descriptionController = TextEditingController(text: selectedProject?.description);
    Uint8List? pickedImageBytes;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Existing Project'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    onChanged: (value) => projects?[i].name = value,
                    decoration: const InputDecoration(
                      labelText: 'Name'),
                  ),
                  TextField(
                    controller: descriptionController,
                    onChanged: (value) =>
                    projects?[i].description = value,
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
                    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                      log('Name or description is empty');
                      return;
                    }
                    if (pickedImageBytes != null) {
                      String? imageURL = await _adminController.uploadImageAndGetURL(
                        pickedImageBytes!,
                        'selected_image.jpg',
                      );
                      if (imageURL != null) {
                        selectedProject?.imageURL = imageURL;
                      }
                    }

                    bool isSuccess = await _adminController.updateProjectData(i, projects![i]) ?? false;
                    if (isSuccess) {
                      setState(() {});
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Updated an existing  project')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to update an existing  project')),
                      );
                    }
                  },
                  child: const Text('Update'),
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


  void _showDeleteDialog(BuildContext context, int i) async { 
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text('Are you sure you want to delete this project?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final deleted = await _adminController.deleteProject(i);
                    Navigator.of(dialogContext).pop(); // Close the dialog.
                    
                    if (deleted) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Project deleted successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to delete the project')),
                      );
                    }
                  },
                  child: const Text('Delete'),
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

