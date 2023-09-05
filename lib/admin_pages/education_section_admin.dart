// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controller/admin_controllers/education_section_admin_controller.dart';
import '../models/Education.dart';
import '../reposervice/education_repo_services.dart';
import 'package:intl/intl.dart';

class EducationSectionAdmin extends StatelessWidget {
  final EducationSectionAdminController _adminController =
      EducationSectionAdminController(EducationRepoService());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              _showEducationList(context, await _adminController.getEducationSectionData() ?? []);
            },
            child: const Text('Edit Education Info'),
          ),
        ],
      ),
    );
  }

  void _showEducationList(BuildContext context, List<Education> educationList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Education List'),
          content: SizedBox(
            width: 200,
            child: educationList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: educationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () {
                          _showEditDialog(context, index);
                        },
                        child: Text(educationList[index].schoolName),
                      );
                    },
                  )
                : const Text('No education data available.'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _showAddNewDialog(context, educationList);
              },
              child: const Text('Add New Education'),
            ),
          ],
        );
      },
    );
  }

  _showAddNewDialog(BuildContext context, List<Education> educationList) async {
    Navigator.of(context).pop();
    final education = Education(
      eid: '',
      startDate: Timestamp.now(),
      endDate: Timestamp.now(),
      logoURL: null,
      schoolName: '',
      degree: '',
      description: '',
    );
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final schoolNameController = TextEditingController();
        final degreeController = TextEditingController();
        final descriptionController = TextEditingController();
        final startDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(education.startDate!.toDate()));
        final endDateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(education.endDate!.toDate()));

        return AlertDialog(
          title: const Text('Add Education'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: schoolNameController,
                  onChanged: (value) => education.schoolName = value,
                  decoration: const InputDecoration(labelText: 'School Name'),
                ),
                TextField(
                  controller: degreeController,
                  onChanged: (value) => education.degree = value,
                  decoration: const InputDecoration(labelText: 'Degree'),
                ),
                TextField(
                  controller: descriptionController,
                  onChanged: (value) => education.description = value,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: startDateController,
                            decoration: const InputDecoration(labelText: 'Start Date'),
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
                              final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              startDateController.text = formattedDate;
                              education.startDate = Timestamp.fromDate(pickedDate);
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
                            decoration: const InputDecoration(labelText: 'End Date'),
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
                              final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              endDateController.text = formattedDate;
                              education.endDate = Timestamp.fromDate(pickedDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                education.create();
                educationList.add(education);
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int i) async {
    Navigator.of(context).pop();
    final educationSectionData = await _adminController.getEducationSectionData();
    final education = educationSectionData![i];

    TextEditingController schoolNameController = 
        TextEditingController(text: education.schoolName);
    TextEditingController degreeController = 
        TextEditingController(text: education.degree);
    TextEditingController descriptionController = 
        TextEditingController(text: education.description);
    TextEditingController startDateController
      = TextEditingController(text: DateFormat('yyyy-MM-dd').format(education.startDate!.toDate()));
    TextEditingController endDateController
      = TextEditingController(text: DateFormat('yyyy-MM-dd').format(education.endDate!.toDate()));


    Uint8List? pickedImageBytes;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit your education information for ${education.schoolName}'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: schoolNameController,
                      onChanged: (value) => educationSectionData[i].schoolName = value,
                      decoration: const InputDecoration(labelText: 'School Name'),
                    ),
                    TextField(
                      controller: degreeController,
                      onChanged: (value) =>
                          educationSectionData[i].degree = value,
                      decoration: const InputDecoration(labelText: 'Degree'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) =>
                          educationSectionData[i].description = value,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: startDateController,
                            decoration: const InputDecoration(labelText: 'Start Date'),
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
                              final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              startDateController.text = formattedDate;
                              education.startDate = Timestamp.fromDate(pickedDate);
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
                            decoration: const InputDecoration(labelText: 'End Date'),
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
                              final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              endDateController.text = formattedDate;
                              education.endDate = Timestamp.fromDate(pickedDate);
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
                TextButton(
                  onPressed: () async {
                    if (pickedImageBytes != null) {
                      String? imageURL =
                          await _adminController.uploadImageAndGetURL(
                              pickedImageBytes!, 'selected_image.jpg');
                      if (imageURL != null) {
                        educationSectionData[i].logoURL = imageURL;
                      }
                    }

                    bool isSuccess = await _adminController
                            .updateEducationSectionData(i, educationSectionData[i]) ??
                        false;
                    if (isSuccess) {
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Failed to update user info')));
                    }
                  },
                  child: const Text('OK'),
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