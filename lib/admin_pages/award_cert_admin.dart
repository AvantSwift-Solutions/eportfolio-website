// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:avantswift_portfolio/controller/admin_controllers/award_cert_admin_controller.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/AwardCert.dart';

class AwardCertAdmin extends StatelessWidget {
  final AwardCertAdminController _adminController =
      AwardCertAdminController(AwardCertRepoService());
  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                _showEditDialog(context, await _adminController.getAwardCertList());
              },
              child: const Text('Edit AwardCert'),
            ),
          ),
        ],
      ),
    );
  }


  void _showEditDialog(BuildContext context, List<AwardCert>? awardCerts) async {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Edit AwardCert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: ()  {
                    Navigator.of(dialogContext).pop();
                    _showAddAwardCertDialog(context, awardCerts!);
                  },
                  child: const Text('Add AwardCert'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    _showExistingAwardCertDialog(context, awardCerts!);
                  },
                  child: const Text('Update Existing AwardCert'),
                ),
              ],
            ),
            actions: <Widget>[
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
  }


  void _showAddAwardCertDialog(BuildContext context, List<AwardCert> awardCerts) {
    TextEditingController nameController = TextEditingController();
    // TextEditingController imageURLController = TextEditingController();
    TextEditingController linkController = TextEditingController();
    TextEditingController sourceController = TextEditingController();
    
    Uint8List? pickedImageBytes;
    AwardCert newAwardCert = AwardCert(acid: '', name: '', link: '', source: '');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add AwardCert'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    onChanged: (value) => newAwardCert.name = value,
                    decoration: const InputDecoration(
                      labelText: 'Name'),
                  ),
                  TextField(
                    controller: linkController,
                    onChanged: (value) =>
                    newAwardCert.link = value,
                    decoration: const InputDecoration(
                      labelText: 'Link'),
                  ),
                  TextField(
                    controller: sourceController,
                    onChanged: (value) =>
                    newAwardCert.source = value,
                    decoration: const InputDecoration(
                      labelText: 'Source'),
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
              actions: <Widget>[
                TextButton(
                  onPressed: () async {                    
                    if (pickedImageBytes != null) {
                      String? imageURL = await _adminController.uploadImageAndGetURL(
                        pickedImageBytes!,
                        'selected_image.jpg',
                      );
                      if (imageURL != null) {
                        newAwardCert.imageURL = imageURL;
                      }
                    }

                    newAwardCert.create();
                    awardCerts.add(newAwardCert);
                    Navigator.of(dialogContext).pop();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added a new AwardCert')),
                    );
                  },
                  child: const Text('Add'),
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


  void _showExistingAwardCertDialog(BuildContext context, List<AwardCert> awardCerts) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('AwardCert List'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: awardCerts.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: awardCerts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(awardCerts[index].name!),
                        // leading: Image.network(awardCerts[index].imageURL),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showUpdateAwardCertDialog(context, index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteDialog(context, index);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _showUpdateAwardCertDialog(context, index);
                        },
                      );
                    },
                  )
                : const Text('No AwardCert available'),
          ), 
          actions: <Widget>[
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
  }


  void _showUpdateAwardCertDialog(BuildContext context, int i) async {
    final awardCerts = await _adminController.getAwardCertList();
    final selectedAwardCert = awardCerts?[i];

    TextEditingController nameController = TextEditingController(text: selectedAwardCert?.name);
    TextEditingController linkController = TextEditingController(text: selectedAwardCert?.link);
    TextEditingController sourceController = TextEditingController(text: selectedAwardCert?.source);
    Uint8List? pickedImageBytes;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Existing AwardCert'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    onChanged: (value) => awardCerts?[i].name = value,
                    decoration: const InputDecoration(
                      labelText: 'Name'),
                  ),
                  TextField(
                    controller: linkController,
                    onChanged: (value) =>
                    awardCerts?[i].link = value,
                    decoration: const InputDecoration(
                      labelText: 'Link'),
                  ),
                  TextField(
                    controller: sourceController,
                    onChanged: (value) =>
                    awardCerts?[i].source = value,
                    decoration: const InputDecoration(
                      labelText: 'Source'),
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
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (pickedImageBytes != null) {
                      String? imageURL = await _adminController.uploadImageAndGetURL(
                        pickedImageBytes!,
                        'selected_image.jpg',
                      );
                      if (imageURL != null) {
                        selectedAwardCert?.imageURL = imageURL;
                      }
                    }

                    bool isSuccess = await _adminController.updateAwardCertData(i, awardCerts![i]) ?? false;
                    if (isSuccess) {
                      setState(() {});
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Updated an existing AwardCert')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to update an existing AwardCert')),
                      );
                    }
                  },
                  child: const Text('Update'),
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


  void _showDeleteDialog(BuildContext context, int i) async { 
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text('Are you sure you want to delete this AwardCert?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final deleted = await _adminController.deleteAwardCert(i);
                    Navigator.of(dialogContext).pop(); // Close the dialog.
                    
                    if (deleted) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('AwardCert deleted successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to delete the AwardCert')),
                      );
                    }
                  },
                  child: const Text('Delete'),
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
