// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controller/admin_controllers/reccomendation_section_admin_controller.dart';
import '../models/Reccomendation.dart';
import '../reposervice/reccomendation_repo_services.dart';
import 'package:intl/intl.dart';

class ReccomendationSectionAdmin extends StatelessWidget {
  final ReccomendationSectionAdminController _adminController =
      ReccomendationSectionAdminController(ReccomendationRepoService());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
              onPressed: () async {
                _showReccomendationList(context, await _adminController.getReccomendationSectionData() ?? []);
              },
              child: const Text('Edit Reccomendation Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showReccomendationList(BuildContext context, List<Reccomendation> reccomendationList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Peer reccomendation List'),
          content: SizedBox(
            width: 200,
            child: reccomendationList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: reccomendationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () {
                          _showEditDialog(context, index);
                        },
                        child: Text(reccomendationList[index].colleagueName!),
                      );
                    },
                  )
                : const Text('No peer reccomendation data available.'),
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
                _showAddNewDialog(context, reccomendationList);
              },
              child: const Text('Add New Peer Reccomendation'),
            ),
          ],
        );
      },
    );
  }

  
  void _showAddNewDialog(BuildContext context, List<Reccomendation> reccomendationList) async {

    final reccomendation = Reccomendation(
      rid: '',
      colleagueName: '',
      colleagueJobTitle: '',
      description: '',
      imageURL: null,
    );

    _showReccomendationDialog(context, reccomendation,
      (recc) async {
        recc.create();
        return true;
      });
  }

  void _showEditDialog(BuildContext context, int i) async {

    final reccomendationSectionData
      = await _adminController.getReccomendationSectionData();
    final experience = reccomendationSectionData![i];

    _showReccomendationDialog(context, experience,
      (recc) async {
        return await _adminController.updateReccomendationSectionData(i, recc)
          ?? false;
      });
  }

  void _showReccomendationDialog(BuildContext context, Reccomendation reccomendation,
    Future<bool> Function(Reccomendation) onReccomendationUpdated) {
      
    TextEditingController colleagueNameController = 
        TextEditingController(text: reccomendation.colleagueName);
    TextEditingController colleagueJobTitleController = 
        TextEditingController(text: reccomendation.colleagueJobTitle);
    TextEditingController descriptionController = 
        TextEditingController(text: reccomendation.description);

    Uint8List? pickedImageBytes;

    String title;
    var newReccomendation = false;
    if (reccomendation.description == '') {
      title = 'Add new peer reccomendation information';
      newReccomendation = true;
    } else {
      title = 'Edit your peer reccomendation information for ${reccomendation.description}';
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
                      controller: colleagueNameController,
                      onChanged: (value) => reccomendation.colleagueName = value,
                      decoration: const InputDecoration(labelText: 'Name of Colleague'),
                    ),
                    TextField(
                      controller: colleagueJobTitleController,
                      onChanged: (value) =>
                          reccomendation.colleagueJobTitle = value,
                      decoration: const InputDecoration(labelText: 'Job Title of Colleague'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) =>
                          reccomendation.description = value,
                      decoration: const InputDecoration(labelText: 'Description of Reccomendation'),
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
                if (!newReccomendation)
                  TextButton(
                    onPressed: () async {
                      final name = reccomendation.colleagueName;
                      reccomendation.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reccomendatiom from $name deleted')));
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
                        reccomendation.imageURL = imageURL;
                      }
                    }
                    bool isSuccess = await onReccomendationUpdated(reccomendation);
                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Peer reccomendation info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error updating peer reccomendation info')));
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