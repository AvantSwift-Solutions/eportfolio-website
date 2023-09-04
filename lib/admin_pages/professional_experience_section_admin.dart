// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controller/admin_controllers/professional_experience_section_admin_controller.dart';
import '../models/ProfessionalExperience.dart';
import '../reposervice/professional_experience_repo_services.dart';

class ProfessionalExperienceSectionAdmin extends StatelessWidget {
  final ProfessionalExperienceSectionAdminController _professionalExperienceController =
      ProfessionalExperienceSectionAdminController(ProfessionalExperienceRepoService());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              _showProfessionalExperienceList(context, await _professionalExperienceController.getProfessionalExperienceSectionData() ?? []);
            },
            child: const Text('Edit Professional Experience Info'),
          ),
        ],
      ),
    );
  }

  void _showProfessionalExperienceList (BuildContext context, List<ProfessionalExperience> professionalExperienceList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Professional Experience History'),
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

  _showAddNewDialog(BuildContext context, List<ProfessionalExperience> professionalExperienceList) async {
    Navigator.of(context).pop();
    final professionalexperience = ProfessionalExperience(
      professionalExperienceId: '',
      jobTitle: '',
      companyName: '',
      location: '',
      logoUrl: '',
      description: '',
      creationTimestamp: null,
    );
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final jobTitleController = TextEditingController();
        final companyNameController = TextEditingController();
        final locationController = TextEditingController();
        final descriptionController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Professional Experience'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: jobTitleController,
                  onChanged: (value) => professionalexperience.jobTitle = value,
                  decoration: const InputDecoration(labelText: 'Job Title'),
                ),
                TextField(
                  controller: companyNameController,
                  onChanged: (value) => professionalexperience.companyName = value,
                  decoration: const InputDecoration(labelText: 'Company Name'),
                ),
                TextField(
                  controller: locationController,
                  onChanged: (value) => professionalexperience.location = value,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: descriptionController,
                  onChanged: (value) => professionalexperience.description = value,
                  decoration: const InputDecoration(labelText: 'Description'),
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
                professionalexperience.create();
                professionalExperienceList.add(professionalexperience);
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
    final professionalExperienceSectionData = await _professionalExperienceController.getProfessionalExperienceSectionData();

    TextEditingController jobTitleController = 
        TextEditingController(text: professionalExperienceSectionData?[i].jobTitle);
    TextEditingController companyNameController = 
        TextEditingController(text: professionalExperienceSectionData?[i].companyName);
    TextEditingController locationController = 
        TextEditingController(text: professionalExperienceSectionData?[i].location);
    TextEditingController descriptionController = 
        TextEditingController(text: professionalExperienceSectionData?[i].description);

    Uint8List? pickedImageBytes;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit your professional experience information for ${professionalExperienceSectionData![i].jobTitle}'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: jobTitleController,
                      onChanged: (value) => professionalExperienceSectionData[i].jobTitle = value,
                      decoration: const InputDecoration(labelText: 'Job Title'),
                    ),
                    TextField(
                      controller: companyNameController,
                      onChanged: (value) =>
                          professionalExperienceSectionData[i].companyName = value,
                      decoration: const InputDecoration(labelText: 'Company Name'),
                    ),
                    TextField(
                      controller: locationController,
                      onChanged: (value) =>
                          professionalExperienceSectionData[i].location = value,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) =>
                          professionalExperienceSectionData[i].description = value,
                      decoration: const InputDecoration(labelText: 'Description'),
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
                          await _professionalExperienceController.uploadImageAndGetURL(
                              pickedImageBytes!, 'selected_image.jpg');
                      if (imageURL != null) {
                        professionalExperienceSectionData[i].logoUrl = imageURL;
                      }
                    }

                    bool isSuccess = await _professionalExperienceController
                            .updateProfessionalExperienceSectionData(i, professionalExperienceSectionData[i]) ??
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