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

  
  void _showAddNewDialog(BuildContext context, List<Education> educationList) async {

    final education = Education(
      eid: '',
      startDate: Timestamp.now(),
      endDate: Timestamp.now(),
      logoURL: null,
      schoolName: '',
      degree: '',
      description: '',
    );

    _showEducationDialog(context, education,
      (edu) async {
        edu.create();
        return true;
      });

  }

  void _showEditDialog(BuildContext context, int i) async {

    final educationSectionData
      = await _adminController.getEducationSectionData();
    final education = educationSectionData![i];

    _showEducationDialog(context, education,
      (edu) async {
        return await _adminController.updateEducationSectionData(i, edu)
          ?? false;
      });

  }

  void _showEducationDialog(BuildContext context, Education education,
    Future<bool> Function(Education) onEducationUpdated) {
      
    TextEditingController schoolNameController = 
        TextEditingController(text: education.schoolName);
    TextEditingController degreeController = 
        TextEditingController(text: education.degree);
    TextEditingController descriptionController = 
        TextEditingController(text: education.description);
    TextEditingController startDateController
      = TextEditingController(text: DateFormat('MMMM d, y').format(education.startDate!.toDate()));
    TextEditingController endDateController
      = TextEditingController(text: DateFormat('MMMM d, y').format(education.endDate!.toDate()));

    Uint8List? pickedImageBytes;

    var title;
    var newEducation = false;
    if (education.schoolName == '') {
      title = 'Add new education information';
      newEducation = true;
    } else {
      title = 'Edit your education information for ${education.schoolName}';
    }

    

    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
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
                      onChanged: (value) =>
                          education.degree = value,
                      decoration: const InputDecoration(labelText: 'Degree'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) =>
                          education.description = value,
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
                              final formattedDate = DateFormat('MMMM d, y').format(pickedDate);
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
                              final formattedDate = DateFormat('MMMM d, y').format(pickedDate);
                              endDateController.text = formattedDate;
                              education.endDate = Timestamp.fromDate(pickedDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    if (pickedImageBytes != null) Image.memory(pickedImageBytes!),
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
                if (!newEducation)
                  TextButton(
                    onPressed: () async {
                      final name = education.schoolName;
                      education.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Education info for $name deleted')));
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('Delete'),
                  ),
                TextButton(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Education info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error updating education info')));
                    }
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
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