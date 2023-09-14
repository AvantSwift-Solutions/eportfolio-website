// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/project_section_admin_controller.dart';
import '../models/Project.dart';
import '../reposervice/project_repo_services.dart';

class ProjectSectionAdmin extends StatelessWidget {
  final ProjectSectionAdminController _adminController =
      ProjectSectionAdminController(ProjectRepoService());
  late final BuildContext parentContext;

  ProjectSectionAdmin({super.key});

  ProjectSectionAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showList(context);
              },
              child: const Text('Edit Personal Project Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<Project> projects =
        await _adminController.getProjectSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Personal Project List'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                projects.isEmpty
                    ? const Text('No Personal Projects available')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(projects[index].name!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(context, index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteDialog(context, projects[index]);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              _showEditDialog(context, index);
                            },
                          );
                        },
                      ),
                TextButton(
                  onPressed: () {
                    _showAddNewDialog(context, projects);
                  },
                  child: const Text('Add New Personal Project'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAddNewDialog(
      BuildContext context, List<Project> projectList) async {
    final id = const Uuid().v4();
    final project = Project(
      ppid: id,
      name: '',
      description: '',
      imageURL: '',
    );

    _showProjectDialog(context, project, (a) async {
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final projectSectionData = await _adminController.getProjectSectionData();
    final project = projectSectionData![i];

    _showProjectDialog(context, project, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showProjectDialog(BuildContext context, Project project,
      Future<bool> Function(Project) onProjectUpdated) {
    TextEditingController nameController =
        TextEditingController(text: project.name);
    TextEditingController descriptionController =
        TextEditingController(text: project.description);
    Uint8List? pickedImageBytes;

    String title, successMessage, errorMessage;
    if (project.name == '') {
      title = 'Add new Personal Project information';
      successMessage = 'Personal Project info added successfully';
      errorMessage = 'Error adding new Personal Project info';
    } else {
      title = 'Edit your Personal Project information for ${project.name}';
      successMessage = 'Personal Project info updated successfully';
      errorMessage = 'Error updating Personal Project info';
    }

    showDialog(
      context:
          parentContext, // Use the parent context instead of the current context
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      onChanged: (value) => project.name = value,
                      decoration:
                          const InputDecoration(labelText: 'Project Name'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) => project.description = value,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
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
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    if (pickedImageBytes != null) {
                      String? imageURL =
                          await _adminController.uploadImageAndGetURL(
                              pickedImageBytes!, 'selected_image.jpg');
                      if (imageURL != null) {
                        project.imageURL = imageURL;
                      }
                    }
                    bool isSuccess = await onProjectUpdated(project);
                    if (isSuccess) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(content: Text(successMessage)),
                      );
                    } else {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                    }
                    Navigator.of(dialogContext).pop(); // Close update dialog
                    Navigator.of(parentContext).pop(); // Close old list dialog
                    _showList(parentContext); // Show new list dialog
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () async {
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

  void _showDeleteDialog(BuildContext context, Project project) async {
    final name = project.name ?? 'Personal Project';

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete $name?'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final deleted = await project.delete();
                    if (deleted) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$name deleted successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete $name')),
                      );
                    }
                    Navigator.of(dialogContext).pop(); // Close delete dialog
                    Navigator.of(parentContext).pop(); // Close old list dialog
                    _showList(parentContext); // Show new list dialog
                  },
                  child: const Text('Delete'),
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
