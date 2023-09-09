// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/recommendation_section_admin_controller.dart';
import '../models/Recommendation.dart';
import '../reposervice/recommendation_repo_services.dart';

class RecommendationSectionAdmin extends StatelessWidget {
  final RecommendationSectionAdminController _adminController =
      RecommendationSectionAdminController(RecommendationRepoService());
  late final BuildContext parentContext;

  RecommendationSectionAdmin({super.key});

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
              child: const Text('Edit Peer Recommendation Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<Recommendation> recommendations =
        await _adminController.getRecommendationSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Peer Recommendation List'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                recommendations.isEmpty
                    ? const Text('No Peer Recommendations available')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(recommendations[index].colleagueName!),
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
                                        context, recommendations[index]);
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
                    _showAddNewDialog(context, recommendations);
                  },
                  child: const Text('Add New Peer Recommendation'),
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
      BuildContext context, List<Recommendation> recommendationList) async {
    final id = const Uuid().v4();
    final recommendation = Recommendation(
      rid: id,
      colleagueName: '',
      colleagueJobTitle: '',
      description: '',
      imageURL: '',
    );

    _showRecommendationDialog(context, recommendation, (a) async {
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final recommendationSectionData =
        await _adminController.getRecommendationSectionData();
    final recommendation = recommendationSectionData![i];

    _showRecommendationDialog(context, recommendation, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showRecommendationDialog(
      BuildContext context,
      Recommendation recommendation,
      Future<bool> Function(Recommendation) onRecommendationUpdated) {
    TextEditingController colleagueNameController =
        TextEditingController(text: recommendation.colleagueName);
    TextEditingController colleagueJobTitleController =
        TextEditingController(text: recommendation.colleagueJobTitle);
    TextEditingController descriptionController =
        TextEditingController(text: recommendation.description);
    Uint8List? pickedImageBytes;

    String title, successMessage, errorMessage;
    if (recommendation.colleagueName == '') {
      title = 'Add new Peer Recommendation information';
      successMessage = 'Peer Recommendation info added successfully';
      errorMessage = 'Error adding new Peer Recommendation info';
    } else {
      title =
          'Edit your Peer Recommendation information from ${recommendation.colleagueName}';
      successMessage = 'Peer Recommendation info updated successfully';
      errorMessage = 'Error updating Peer Recommendation info';
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
                      controller: colleagueNameController,
                      onChanged: (value) =>
                          recommendation.colleagueName = value,
                      decoration:
                          const InputDecoration(labelText: 'Colleague Name'),
                    ),
                    TextField(
                      controller: colleagueJobTitleController,
                      onChanged: (value) =>
                          recommendation.colleagueJobTitle = value,
                      decoration: const InputDecoration(
                          labelText: 'Colleague Job Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) => recommendation.description = value,
                      decoration: const InputDecoration(
                          labelText: 'Description of Recommendation'),
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
                        recommendation.imageURL = imageURL;
                      }
                    }
                    bool isSuccess =
                        await onRecommendationUpdated(recommendation);
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

  void _showDeleteDialog(
      BuildContext context, Recommendation recommendation) async {
    final name = recommendation.colleagueName ?? 'Peer Recommendation';

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
                    final deleted = await recommendation.delete();
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
