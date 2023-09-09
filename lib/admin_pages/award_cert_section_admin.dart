// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/award_cert_section_admin_controller.dart';
import '../models/AwardCert.dart';
import '../reposervice/award_cert_repo_services.dart';

class AwardCertSectionAdmin extends StatelessWidget {
  final AwardCertSectionAdminController _adminController =
      AwardCertSectionAdminController(AwardCertRepoService());
  late final BuildContext parentContext;

  AwardCertSectionAdmin({super.key});

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
              child: const Text('Edit Award & Certification Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<AwardCert> awardcerts =
        await _adminController.getAwardCertSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Award & Certification List'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                awardcerts.isEmpty
                    ? const Text('No Award & Certifications available')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: awardcerts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(awardcerts[index].name!),
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
                                        context, awardcerts[index]);
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
                    _showAddNewDialog(context, awardcerts);
                  },
                  child: const Text('Add New Award & Certification'),
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
      BuildContext context, List<AwardCert> awardcertList) async {
    final id = const Uuid().v4();
    final awardcert = AwardCert(
      acid: id,
      name: '',
      link: '',
      source: '',
      imageURL: '',
    );

    _showAwardCertDialog(context, awardcert, (a) async {
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final awardcertSectionData =
        await _adminController.getAwardCertSectionData();
    final awardcert = awardcertSectionData![i];

    _showAwardCertDialog(context, awardcert, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showAwardCertDialog(BuildContext context, AwardCert awardcert,
      Future<bool> Function(AwardCert) onAwardCertUpdated) {
    TextEditingController nameController =
        TextEditingController(text: awardcert.name);
    TextEditingController linkController =
        TextEditingController(text: awardcert.link);
    TextEditingController sourceController =
        TextEditingController(text: awardcert.source);
    Uint8List? pickedImageBytes;

    String title, successMessage, errorMessage;
    if (awardcert.name == '') {
      title = 'Add new Award & Certification information';
      successMessage = 'Award & Certification info added successfully';
      errorMessage = 'Error adding new Award & Certification info';
    } else {
      title =
          'Edit your Award & Certification information for ${awardcert.name}';
      successMessage = 'Award & Certification info updated successfully';
      errorMessage = 'Error updating Award & Certification info';
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
                      onChanged: (value) => awardcert.name = value,
                      decoration: const InputDecoration(
                          labelText: 'Award/Certification Name'),
                    ),
                    TextField(
                      controller: linkController,
                      onChanged: (value) => awardcert.link = value,
                      decoration: const InputDecoration(labelText: 'Link'),
                    ),
                    TextField(
                      controller: sourceController,
                      onChanged: (value) => awardcert.source = value,
                      decoration: const InputDecoration(labelText: 'Source'),
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
                        awardcert.imageURL = imageURL;
                      }
                    }
                    bool isSuccess = await onAwardCertUpdated(awardcert);
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

  void _showDeleteDialog(BuildContext context, AwardCert awardcert) async {
    final name = awardcert.name ?? 'Award & Certification';

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
                    final deleted = await awardcert.delete();
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
