// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controller/admin_controllers/professional_experience_section_admin_controller.dart';
import '../models/ProfessionalExperience.dart';
import '../reposervice/professional_experience_repo_services.dart';
import 'package:intl/intl.dart';

class ProfessionalExperienceSectionAdmin extends StatelessWidget {
  final ProfessionalExperienceSectionAdminController _adminController =
      ProfessionalExperienceSectionAdminController(ProfessionalExperienceRepoService());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
              onPressed: () async {
                _showProfessionalExperienceList(context, await _adminController.getProfessionalExperienceSectionData() ?? []);
              },
              child: const Text('Edit Professional Experience Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfessionalExperienceList(BuildContext context, List<ProfessionalExperience> professionalExperienceList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Professional Experience List'),
          content: SizedBox(
            width: 200,
            child: professionalExperienceList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: professionalExperienceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () {
                          _showEditDialog(context, index);
                        },
                        child: Text(professionalExperienceList[index].jobTitle),
                      );
                    },
                  )
                : const Text('No professional experience data available.'),
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
                _showAddNewDialog(context, professionalExperienceList);
              },
              child: const Text('Add New Professional Experience'),
            ),
          ],
        );
      },
    );
  }

  
  void _showAddNewDialog(BuildContext context, List<ProfessionalExperience> professionalExperienceList) async {

    final professionalExperience = ProfessionalExperience(
      professionalExperienceId: '',
      jobTitle: '',
      companyName: '',
      location: '',
      startDate: Timestamp.now(),
      endDate: Timestamp.now(),
      description: '',
      logoURL: null,
    );

    _showProfessionalExperienceDialog(context, professionalExperience,
      (exp) async {
        exp.create();
        return true;
      });
  }

  void _showEditDialog(BuildContext context, int i) async {

    final professionalExperienceSectionData
      = await _adminController.getProfessionalExperienceSectionData();
    final experience = professionalExperienceSectionData![i];

    _showProfessionalExperienceDialog(context, experience,
      (exp) async {
        return await _adminController.updateProfessionalExperienceSectionData(i, exp)
          ?? false;
      });
  }

  void _showProfessionalExperienceDialog(BuildContext context, ProfessionalExperience experience,
    Future<bool> Function(ProfessionalExperience) onProfessionalExperienceUpdated) {
      
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
    var newProfessionalExperience = false;
    if (experience.jobTitle == '') {
      title = 'Add new professional experience information';
      newProfessionalExperience = true;
    } else {
      title = 'Edit your professional experience information for ${experience.jobTitle}';
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
                if (!newProfessionalExperience)
                  TextButton(
                    onPressed: () async {
                      final name = experience.jobTitle;
                      experience.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Professional experience info for $name deleted')));
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
                    bool isSuccess = await onProfessionalExperienceUpdated(experience);
                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Professional experience info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error updating professional experience info')));
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