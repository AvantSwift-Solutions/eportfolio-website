// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/education_section_admin_controller.dart';
import '../models/Education.dart';
import '../reposervice/education_repo_services.dart';

class EducationSectionAdmin extends StatelessWidget {
  final EducationSectionAdminController _adminController =
      EducationSectionAdminController(EducationRepoService());
  late final BuildContext parentContext;

  EducationSectionAdmin({super.key});

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
              child: const Text('Edit Education Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<Education> educations =
        await _adminController.getEducationSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Education List'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                educations.isEmpty
                    ? const Text('No Educations available')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: educations.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(educations[index].schoolName!),
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
                                    _showDeleteDialog(
                                        context, educations[index]);
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
                    _showAddNewDialog(context, educations);
                  },
                  child: const Text('Add New Education'),
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
      BuildContext context, List<Education> educationList) async {
    final id = const Uuid().v4();
    final education = Education(
      eid: id,
      startDate: Timestamp.now(),
      endDate: Timestamp.now(),
      logoURL: null,
      schoolName: '',
      degree: '',
      description: '',
    );

    _showEducationDialog(context, education, (education) async {
      return await education.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final educationSectionData =
        await _adminController.getEducationSectionData();
    final education = educationSectionData![i];

    _showEducationDialog(context, education, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showEducationDialog(BuildContext context, Education education,
      Future<bool> Function(Education) onEducationUpdated) {
    TextEditingController nameController =
        TextEditingController(text: education.schoolName);
    TextEditingController degreeController =
        TextEditingController(text: education.degree);
    TextEditingController descriptionController =
        TextEditingController(text: education.description);
    TextEditingController startDateController = TextEditingController(
        text: DateFormat('MMMM d, y').format(education.startDate!.toDate()));
    TextEditingController endDateController = TextEditingController(
        text: DateFormat('MMMM d, y').format(education.endDate!.toDate()));
    Uint8List? pickedImageBytes;

    String title, successMessage, errorMessage;
    if (education.schoolName == '') {
      title = 'Add new Education information';
      successMessage = 'Education info added successfully';
      errorMessage = 'Error adding new Education info';
    } else {
      title = 'Edit your Education information for ${education.schoolName}';
      successMessage = 'Education info updated successfully';
      errorMessage = 'Error updating Education info';
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
                      onChanged: (value) => education.schoolName = value,
                      decoration:
                          const InputDecoration(labelText: 'School Name'),
                    ),
                    TextField(
                      controller: degreeController,
                      onChanged: (value) => education.degree = value,
                      decoration: const InputDecoration(labelText: 'Degree'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) => education.description = value,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: startDateController,
                            decoration:
                                const InputDecoration(labelText: 'Start Date'),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: education.startDate!.toDate(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              final formattedDate =
                                  DateFormat('MMMM d, y').format(pickedDate);
                              startDateController.text = formattedDate;
                              education.startDate =
                                  Timestamp.fromDate(pickedDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: endDateController,
                            decoration:
                                const InputDecoration(labelText: 'End Date'),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: education.endDate!.toDate(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              final formattedDate =
                                  DateFormat('MMMM d, y').format(pickedDate);
                              endDateController.text = formattedDate;
                              education.endDate =
                                  Timestamp.fromDate(pickedDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
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
                        education.logoURL = imageURL;
                      }
                    }
                    bool isSuccess = await onEducationUpdated(education);
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

  void _showDeleteDialog(BuildContext context, Education education) async {
    final name = education.schoolName ?? 'Education';

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
                    final deleted = await education.delete();
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
