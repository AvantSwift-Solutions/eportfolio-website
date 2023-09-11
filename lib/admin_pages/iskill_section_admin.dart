// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/iskill_section_admin_controller.dart';
import '../models/ISkill.dart';
import '../reposervice/iskill_repo_services.dart';

class ISkillSectionAdmin extends StatelessWidget {
  final ISkillSectionAdminController _adminController =
      ISkillSectionAdminController(ISkillRepoService());
  late final BuildContext parentContext;

  ISkillSectionAdmin({super.key});

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
              child: const Text('Edit Interpersonal Skill Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<ISkill> iskills = await _adminController.getSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Interpersonal Skill List'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                iskills.isEmpty
                    ? const Text('No Interpersonal Skills available')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: iskills.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(iskills[index].name!),
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
                                    _showDeleteDialog(context, iskills[index]);
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
                    _showAddNewDialog(context, iskills);
                  },
                  child: const Text('Add New Interpersonal Skill'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ReorderDialog(controller: _adminController, onReorder: () {
              Navigator.of(dialogContext).pop(); // Close reorder dialog
              Navigator.of(parentContext).pop(); // Close old list dialog
              _showList(parentContext); // Show new list dialog
            },),
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

  void _showAddNewDialog(BuildContext context, List<ISkill> iskillList) async {
    final id = const Uuid().v4();
    final iskill = ISkill(
      isid: id,
      index: iskillList.length,
      name: '',
    );

    _showISkillDialog(context, iskill, (skill) async {
      return await skill.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final iskillSectionData = await _adminController.getSectionData();
    final iskill = iskillSectionData![i];

    _showISkillDialog(context, iskill, (skill) async {
      return await skill.update() ?? false;
    });
  }

  void _showISkillDialog(BuildContext context, ISkill iskill,
      Future<bool> Function(ISkill) onISkillUpdated) {
    TextEditingController nameController =
        TextEditingController(text: iskill.name);

    String title, successMessage, errorMessage;
    if (iskill.name == '') {
      title = 'Add new Interpersonal Skill information';
      successMessage = 'Interpersonal Skill info added successfully';
      errorMessage = 'Error adding new Interpersonal Skill info';
    } else {
      title = 'Edit your Interpersonal Skill information for ${iskill.name}';
      successMessage = 'Interpersonal Skill info updated successfully';
      errorMessage = 'Error updating Interpersonal Skill info';
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
                      onChanged: (value) => iskill.name = value,
                      decoration:
                          const InputDecoration(labelText: 'Skill Name'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    bool isSuccess = await onISkillUpdated(iskill);
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

  void _showDeleteDialog(BuildContext context, ISkill skill) async {
    final name = skill.name ?? 'Interpersonal Skill';

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
}
