// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:flutter/material.dart';
import '../controller/admin_controllers/iskill_section_admin_controller.dart';
import '../models/ISkill.dart';
import '../reposervice/iskill_repo_services.dart';

class ISkillSectionAdmin extends StatelessWidget {
  final ISkillSectionAdminController _adminController =
      ISkillSectionAdminController(ISkillRepoService());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                _showISkillList(context, await _adminController.getISkillSectionData() ?? []);
              },
              child: const Text('Edit Interpersonal Skill Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showISkillList(BuildContext context, List<ISkill> iskillList) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Interpersonal Skill List'),
          content: SizedBox(
            width: 200,
            child: iskillList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: iskillList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () {
                          _showEditDialog(context, index);
                        },
                        child: Text(iskillList[index].name!),
                      );
                    },
                  )
                : const Text('No interpersonal skill data available.'),
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
                _showAddNewDialog(context, iskillList);
              },
              child: const Text('Add New Interpersonal Skill'),
            ),
          ],
        );
      },
    );
  }

  
  void _showAddNewDialog(BuildContext context, List<ISkill> iskillList) async {

    final iskill = ISkill(
      isid: '',
      name: '',
    );

    _showISkillDialog(context, iskill,
      (skill) async {
        skill.create();
        return true;
      });

  }

  void _showEditDialog(BuildContext context, int i) async {

    final iskillSectionData
      = await _adminController.getISkillSectionData();
    final iskill = iskillSectionData![i];

    _showISkillDialog(context, iskill,
      (skill) async {
        return await _adminController.updateISkillSectionData(i, skill)
          ?? false;
      });

  }

  void _showISkillDialog(BuildContext context, ISkill iskill,
    Future<bool> Function(ISkill) onISkillUpdated) {
      
    TextEditingController nameController = 
        TextEditingController(text: iskill.name);

    String title;
    var newISkill = false;
    if (iskill.name == '') {
      title = 'Add new interpersonal skill information';
      newISkill = true;
    } else {
      title = 'Edit your interpersonal skill information for ${iskill.name}';
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
                      onChanged: (value) => iskill.name = value,
                      decoration: const InputDecoration(labelText: 'Skill Name'),
                    ),                    
                  ],
                ),
              ),
              actions: <Widget>[
                if (!newISkill)
                  TextButton(
                    onPressed: () async {
                      final name = iskill.name;
                      iskill.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Interpersonal skill info for $name deleted')));
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('Delete'),
                  ),
                TextButton(
                  onPressed: () async {
                    bool isSuccess = await onISkillUpdated(iskill);
                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Interpersonal skill info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error updating interpersonal skill info')));
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

}