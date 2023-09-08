// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controller/admin_controllers/recommendation_section_admin_controller.dart';
import '../models/Recommendation.dart';
import '../reposervice/recommendation_repo_services.dart';

class RecommendationSectionAdmin extends StatelessWidget {
  final RecommendationSectionAdminController _adminController =
      RecommendationSectionAdminController(RecommendationRepoService());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
              onPressed: () async {
                _showRecommendationList(context, await _adminController.getRecommendationSectionData() ?? []);
              },
              child: const Text('Edit Recommendation Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showRecommendationList(BuildContext context, List<Recommendation> recommendationList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Peer recommendation List'),
          content: SizedBox(
            width: 200,
            child: recommendationList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: recommendationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () {
                          _showEditDialog(context, index);
                        },
                        child: Text(recommendationList[index].colleagueName!),
                      );
                    },
                  )
                : const Text('No peer recommendation data available.'),
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
                _showAddNewDialog(context, recommendationList);
              },
              child: const Text('Add New Peer Recommendation'),
            ),
          ],
        );
      },
    );
  }

  
  void _showAddNewDialog(BuildContext context, List<Recommendation> recommendationList) async {

    final recommendation = Recommendation(
      rid: '',
      colleagueName: '',
      colleagueJobTitle: '',
      description: '',
      imageURL: null,
    );

    _showRecommendationDialog(context, recommendation,
      (recc) async {
        recc.create();
        return true;
      });
  }

  void _showEditDialog(BuildContext context, int i) async {

    final recommendationSectionData
      = await _adminController.getRecommendationSectionData();
    final experience = recommendationSectionData![i];

    _showRecommendationDialog(context, experience,
      (recc) async {
        return await _adminController.updateRecommendationSectionData(i, recc)
          ?? false;
      });
  }

  void _showRecommendationDialog(BuildContext context, Recommendation recommendation,
    Future<bool> Function(Recommendation) onRecommendationUpdated) {
      
    TextEditingController colleagueNameController = 
        TextEditingController(text: recommendation.colleagueName);
    TextEditingController colleagueJobTitleController = 
        TextEditingController(text: recommendation.colleagueJobTitle);
    TextEditingController descriptionController = 
        TextEditingController(text: recommendation.description);

    Uint8List? pickedImageBytes;

    String title;
    var newRecommendation = false;
    if (recommendation.description == '') {
      title = 'Add new peer recommendation information';
      newRecommendation = true;
    } else {
      title = 'Edit your peer recommendation information for ${recommendation.description}';
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
                      onChanged: (value) => recommendation.colleagueName = value,
                      decoration: const InputDecoration(labelText: 'Name of Colleague'),
                    ),
                    TextField(
                      controller: colleagueJobTitleController,
                      onChanged: (value) =>
                          recommendation.colleagueJobTitle = value,
                      decoration: const InputDecoration(labelText: 'Job Title of Colleague'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) =>
                          recommendation.description = value,
                      decoration: const InputDecoration(labelText: 'Description of Recommendation'),
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
                if (!newRecommendation)
                  TextButton(
                    onPressed: () async {
                      final name = recommendation.colleagueName;
                      recommendation.delete();
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
                        recommendation.imageURL = imageURL;
                      }
                    }
                    bool isSuccess = await onRecommendationUpdated(recommendation);
                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Peer recommendation info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error updating peer recommendation info')));
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