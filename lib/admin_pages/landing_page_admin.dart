// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controllers/admin_controllers/landing_page_admin_controller.dart';

class LandingPageAdmin extends StatelessWidget {
  final LandingPageAdminController _adminController =
      LandingPageAdminController(UserRepoService());

  LandingPageAdmin({super.key});

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
              child: const Text('Edit User Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) async {
    final landingPageData = await _adminController.getLandingPageData();

    TextEditingController nameController =
        TextEditingController(text: landingPageData!.name);
    TextEditingController titleController =
        TextEditingController(text: landingPageData.nickname);
    TextEditingController descriptionController =
        TextEditingController(text: landingPageData.landingPageDescription);

    Uint8List? pickedImageBytes;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit your landing page information'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      onChanged: (value) => landingPageData.name = value,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: titleController,
                      onChanged: (value) => landingPageData.nickname = value,
                      decoration: const InputDecoration(labelText: 'Nickname'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) =>
                          landingPageData.landingPageDescription = value,
                      decoration: const InputDecoration(
                          labelText: 'Landing Page Description'),
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
                              pickedImageBytes!, 'landing_page');
                      if (imageURL != null) {
                        landingPageData.imageURL = imageURL;
                      }
                    }

                    bool isSuccess = await _adminController
                            .updateLandingPageData(landingPageData) ??
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
