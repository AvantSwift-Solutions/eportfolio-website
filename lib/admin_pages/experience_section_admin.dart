// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controllers/admin_controllers/experience_section_admin_controller.dart';
import '../models/Experience.dart';
import '../reposervice/experience_repo_services.dart';
import 'package:intl/intl.dart';

class ExperienceSectionAdmin extends StatelessWidget {
  final ExperienceSectionAdminController _adminController =
      ExperienceSectionAdminController(ExperienceRepoService());

  ExperienceSectionAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
              onPressed: () async {
                _showExperienceList(context, await _adminController.getExperienceSectionData() ?? []);
              },
              child: const Text('Edit  Experience Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showExperienceList(BuildContext context, List<Experience> experienceList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(' Experience List'),
          content: SizedBox(
            width: 200,
            child: experienceList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: experienceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () {
                          _showEditDialog(context, index);
                        },
                        child: Text(experienceList[index].jobTitle!),
                      );
                    },
                  )
                : const Text('No  experience data available.'),
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
                _showAddNewDialog(context, experienceList);
              },
              child: const Text('Add New  Experience'),
            ),
          ],
        );
      },
    );
  }

  
  void _showAddNewDialog(BuildContext context, List<Experience> experienceList) async {

    final experience = Experience(
      peid: '',
      jobTitle: '',
      companyName: '',
      location: '',
      startDate: Timestamp.now(),
      endDate: Timestamp.now(),
      description: '',
      logoURL: null,
    );

    _showExperienceDialog(context, experience,
      (exp) async {
        exp.create();
        return true;
      });
  }

  void _showEditDialog(BuildContext context, int i) async {

    final experienceSectionData
      = await _adminController.getExperienceSectionData();
    final experience = experienceSectionData![i];

    _showExperienceDialog(context, experience,
      (exp) async {
        return await _adminController.updateExperienceSectionData(i, exp)
          ?? false;
      });
  }

  void _showExperienceDialog(BuildContext context, Experience experience,
    Future<bool> Function(Experience) onExperienceUpdated) {
      
    TextEditingController jobTitleController = 
        TextEditingController(text: experience.jobTitle);
    TextEditingController companyNameController = 
        TextEditingController(text: experience.companyName);
    TextEditingController locationController = 
        TextEditingController(text: experience.location);
    TextEditingController descriptionController = 
        TextEditingController(text: experience.description);
    TextEditingController startDateController
      = TextEditingController(text: DateFormat('MMMM d, y').format(experience.startDate!.toDate()));
    TextEditingController endDateController
      = TextEditingController(text: DateFormat('MMMM d, y').format(experience.endDate!.toDate()));

    Uint8List? pickedImageBytes;

    String title;
    var newExperience = false;
    if (experience.jobTitle == '') {
      title = 'Add new  experience information';
      newExperience = true;
    } else {
      title = 'Edit your  experience information for ${experience.jobTitle}';
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
                      controller: jobTitleController,
                      onChanged: (value) => experience.jobTitle = value,
                      decoration: const InputDecoration(labelText: 'Job Title'),
                    ),
                    TextField(
                      controller: companyNameController,
                      onChanged: (value) =>
                          experience.companyName = value,
                      decoration: const InputDecoration(labelText: 'Company Name'),
                    ),
                    TextField(
                      controller: locationController,
                      onChanged: (value) =>
                          experience.location = value,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) =>
                          experience.description = value,
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
                              initialDate: experience.startDate!.toDate(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              final formattedDate = DateFormat('MMMM d, y').format(pickedDate);
                              startDateController.text = formattedDate;
                              experience.startDate = Timestamp.fromDate(pickedDate);
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
                              initialDate: experience.endDate!.toDate(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              final formattedDate = DateFormat('MMMM d, y').format(pickedDate);
                              endDateController.text = formattedDate;
                              experience.endDate = Timestamp.fromDate(pickedDate);
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
                if (!newExperience)
                  TextButton(
                    onPressed: () async {
                      final name = experience.jobTitle;
                      experience.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(' experience info for $name deleted')));
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
                        experience.logoURL = imageURL;
                      }
                    }
                    bool isSuccess = await onExperienceUpdated(experience);
                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(' experience info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error updating  experience info')));
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