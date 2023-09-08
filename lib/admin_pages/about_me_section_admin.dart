// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controllers/admin_controllers/about_me_section_admin_controller.dart';

class AboutMeSectionAdmin extends StatelessWidget {
  final AboutMeSectionAdminController _adminController =
      AboutMeSectionAdminController(UserRepoService());

  AboutMeSectionAdmin({super.key});

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
              child: const Text('Edit About Me'),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) async {
    final aboutMeSectionData = await _adminController.getAboutMeSectionData();

    TextEditingController aboutMeController =
        TextEditingController(text: aboutMeSectionData!.aboutMe);

    Uint8List? pickedImageBytes;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit About Me'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: aboutMeController,
                      onChanged: (value) => aboutMeSectionData.aboutMe = value,
                      decoration: const InputDecoration(labelText: 'About Me'),
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
                        aboutMeSectionData.imageURL = imageURL;
                      }
                    }

                    bool isSuccess = await _adminController
                            .updateAboutMeSectionData(aboutMeSectionData) ??
                        false;
                    if (isSuccess) {
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('About Me updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Failed to update about me info')));
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
