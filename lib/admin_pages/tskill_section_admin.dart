// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/tskill_section_admin_controller.dart';
import '../models/TSkill.dart';
import '../reposervice/tskill_repo_services.dart';

class TSkillSectionAdmin extends StatelessWidget {
  final TSkillSectionAdminController _adminController =
      TSkillSectionAdminController(TSkillRepoService());
  late final BuildContext parentContext;

  TSkillSectionAdmin({super.key});

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
              child: const Text('Edit Technical Skill Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<TSkill> tskills = await _adminController.getTSkillSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Technical Skill List'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                tskills.isEmpty
                    ? const Text('No Technical Skills available')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: tskills.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(tskills[index].name!),
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
                                    _showDeleteDialog(context, tskills[index]);
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
                    _showAddNewDialog(context, tskills);
                  },
                  child: const Text('Add New Technical Skill'),
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

  void _showAddNewDialog(BuildContext context, List<TSkill> tskillList) async {
    final id = const Uuid().v4();
    final tskill = TSkill(
      tsid: id,
      name: '',
      imageURL: '',
    );

    _showTSkillDialog(context, tskill, (skill) async {
      return await skill.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final tskillSectionData = await _adminController.getTSkillSectionData();
    final tskill = tskillSectionData![i];

    _showTSkillDialog(context, tskill, (skill) async {
      return await skill.update() ?? false;
    });
  }

  void _showTSkillDialog(BuildContext context, TSkill tskill,
      Future<bool> Function(TSkill) onTSkillUpdated) {
    TextEditingController nameController =
        TextEditingController(text: tskill.name);
    Uint8List? pickedImageBytes;

    String title, successMessage, errorMessage;
    if (tskill.name == '') {
      title = 'Add new Technical Skill information';
      successMessage = 'Technical Skill info added successfully';
      errorMessage = 'Error adding new Technical Skill info';
    } else {
      title = 'Edit your Technical Skill information for ${tskill.name}';
      successMessage = 'Technical Skill info updated successfully';
      errorMessage = 'Error updating Technical Skill info';
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
                      onChanged: (value) => tskill.name = value,
                      decoration:
                          const InputDecoration(labelText: 'Skill Name'),
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
                        tskill.imageURL = imageURL;
                      }
                    }
                    bool isSuccess = await onTSkillUpdated(tskill);
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

  void _showDeleteDialog(BuildContext context, TSkill skill) async {
    final name = skill.name ?? 'Technical Skill';

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
                    final deleted = await skill.delete();
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
