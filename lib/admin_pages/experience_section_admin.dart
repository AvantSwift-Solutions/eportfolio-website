// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/experience_section_admin_controller.dart';
import '../models/Experience.dart';
import '../reposervice/experience_repo_services.dart';

class ExperienceSectionAdmin extends StatelessWidget {
  final ExperienceSectionAdminController _adminController =
      ExperienceSectionAdminController(ExperienceRepoService());
  late final BuildContext parentContext;

  ExperienceSectionAdmin({super.key});

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
              child: const Text('Edit Professional Experience Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<Experience> experiences =
        await _adminController.getExperienceSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Professional Experience List'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                experiences.isEmpty
                    ? const Text('No Professional Experiences available')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: experiences.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(experiences[index].companyName!),
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
                                        context, experiences[index]);
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
                    _showAddNewDialog(context, experiences);
                  },
                  child: const Text('Add New Professional Experience'),
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
      BuildContext context, List<Experience> experienceList) async {
    final id = const Uuid().v4();
    final experience = Experience(
      peid: id,
      jobTitle: '',
      companyName: '',
      location: '',
      startDate: Timestamp.now(),
      endDate: Timestamp.now(),
      description: '',
    );

    _showExperienceDialog(context, experience, (a) async {
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final experienceSectionData =
        await _adminController.getExperienceSectionData();
    final experience = experienceSectionData![i];

    _showExperienceDialog(context, experience, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showExperienceDialog(BuildContext context, Experience experience,
      Future<bool> Function(Experience) onExperienceUpdated) {
    TextEditingController nameController =
        TextEditingController(text: experience.companyName);
    TextEditingController jobTitleController =
        TextEditingController(text: experience.jobTitle);
    TextEditingController locationController =
        TextEditingController(text: experience.location);
    TextEditingController startDateController = TextEditingController(
        text: DateFormat('MMMM d, y').format(experience.startDate!.toDate()));
    TextEditingController endDateController = TextEditingController(
        text: DateFormat('MMMM d, y').format(experience.endDate!.toDate()));
    TextEditingController descriptionController =
        TextEditingController(text: experience.description);
    Uint8List? pickedImageBytes;

    String title, successMessage, errorMessage;
    if (experience.companyName == '') {
      title = 'Add new Professional Experience information';
      successMessage = 'Professional Experience info added successfully';
      errorMessage = 'Error adding new Professional Experience info';
    } else {
      title =
          'Edit your Professional Experience information for ${experience.companyName}';
      successMessage = 'Professional Experience info updated successfully';
      errorMessage = 'Error updating Professional Experience info';
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
                      onChanged: (value) => experience.companyName = value,
                      decoration:
                          const InputDecoration(labelText: 'Company Name'),
                    ),
                    TextField(
                      controller: jobTitleController,
                      onChanged: (value) => experience.jobTitle = value,
                      decoration: const InputDecoration(labelText: 'Job Title'),
                    ),
                    TextField(
                      controller: locationController,
                      onChanged: (value) => experience.location = value,
                      decoration: const InputDecoration(labelText: 'Location'),
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
                              initialDate: experience.startDate!.toDate(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              final formattedDate =
                                  DateFormat('MMMM d, y').format(pickedDate);
                              startDateController.text = formattedDate;
                              experience.startDate =
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
                              initialDate: experience.endDate!.toDate(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              final formattedDate =
                                  DateFormat('MMMM d, y').format(pickedDate);
                              endDateController.text = formattedDate;
                              experience.endDate =
                                  Timestamp.fromDate(pickedDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) => experience.description = value,
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
                        experience.logoURL = imageURL;
                      }
                    }
                    bool isSuccess = await onExperienceUpdated(experience);
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

  void _showDeleteDialog(BuildContext context, Experience experience) async {
    final name = experience.companyName ?? 'Experience';

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
                    final deleted = await experience.delete();
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
