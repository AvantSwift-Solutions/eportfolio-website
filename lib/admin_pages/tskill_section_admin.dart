// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controllers/admin_controllers/tskill_section_admin_controller.dart';
import '../models/TSkill.dart';
import '../reposervice/tskill_repo_services.dart';

class TSkillSectionAdmin extends StatelessWidget {
  final TSkillSectionAdminController _adminController =
      TSkillSectionAdminController(TSkillRepoService());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                _showTSkillList(context, await _adminController.getTSkillSectionData() ?? []);
              },
              child: const Text('Edit Technical Skill Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showTSkillList(BuildContext context, List<TSkill> tskillList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Technical Skill List'),
          content: SizedBox(
            width: 200,
            child: tskillList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: tskillList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () {
                          _showEditDialog(context, index);
                        },
                        child: Text(tskillList[index].name!),
                      );
                    },
                  )
                : const Text('No technical skill data available.'),
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
                _showAddNewDialog(context, tskillList);
              },
              child: const Text('Add New Technical Skill'),
            ),
          ],
        );
      },
    );
  }

  
  void _showAddNewDialog(BuildContext context, List<TSkill> tskillList) async {

    final tskill = TSkill(
      tsid: '',
      name: '',
    );

    _showTSkillDialog(context, tskill,
      (skill) async {
        skill.create();
        return true;
      });

  }

  void _showEditDialog(BuildContext context, int i) async {

    final tskillSectionData
      = await _adminController.getTSkillSectionData();
    final tskill = tskillSectionData![i];

    _showTSkillDialog(context, tskill,
      (skill) async {
        return await _adminController.updateTSkillSectionData(i, skill)
          ?? false;
      });

  }

  void _showTSkillDialog(BuildContext context, TSkill tskill,
    Future<bool> Function(TSkill) onTSkillUpdated) {
      
    TextEditingController nameController = 
        TextEditingController(text: tskill.name);

    Uint8List? pickedImageBytes;

    String title;
    var newTSkill = false;
    if (tskill.name == '') {
      title = 'Add new technical skill information';
      newTSkill = true;
    } else {
      title = 'Edit your technical skill information for ${tskill.name}';
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
                      controller: nameController,
                      onChanged: (value) => tskill.name = value,
                      decoration: const InputDecoration(labelText: 'Skill Name'),
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
                if (!newTSkill)
                  TextButton(
                    onPressed: () async {
                      final name = tskill.name;
                      tskill.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Technical skill info for $name deleted')));
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
                        tskill.imageURL = imageURL;
                      }
                    }
                    bool isSuccess = await onTSkillUpdated(tskill);
                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Technical skill info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error updating technical skill info')));
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