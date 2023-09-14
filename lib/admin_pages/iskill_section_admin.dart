// ignore_for_file: use_build_context_synchronously

import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
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
        return Theme(
          data: AdminViewDialogStyles.dialogThemeData,
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit Interpersonal Skills'),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ),
              ],
            ),
            contentPadding: AdminViewDialogStyles.contentPadding,
            content: SizedBox(
              width: AdminViewDialogStyles.listDialogWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  iskills.isEmpty
                      ? const Text('No Interpersonal Skills available')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: iskills.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                tileColor: Colors.white,
                                title: Text(iskills[index].name!,
                                    style: AdminViewDialogStyles.listTextStyle),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: Colors.black,
                                      onPressed: () {
                                        _showEditDialog(context, index);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.black,
                                      onPressed: () {
                                        _showDeleteDialog(
                                            context, iskills, index);
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _showEditDialog(context, index);
                                },
                              ),
                            );
                          },
                        ),
                  const Divider(),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: AdminViewDialogStyles.actionPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReorderDialog(
                      controller: _adminController,
                      onReorder: () {
                        Navigator.of(dialogContext)
                            .pop(); // Close reorder dialog
                        Navigator.of(parentContext)
                            .pop(); // Close old list dialog
                        _showList(parentContext); // Show new list dialog
                      },
                    ),
                    ElevatedButton(
                      style: AdminViewDialogStyles.elevatedButtonStyle,
                      onPressed: () {
                        _showAddNewDialog(context, iskills);
                      },
                      child: Text(
                        'Add New',
                        style: AdminViewDialogStyles.buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String title, successMessage, errorMessage;
    if (iskill.name == '') {
      title = 'Add New Interpersonal Skill';
      successMessage = 'Interpersonal Skill info added successfully';
      errorMessage = 'Error adding new Interpersonal Skill info';
    } else {
      title = 'Edit info for \'${iskill.name}\'';
      successMessage = 'Interpersonal Skill info updated successfully';
      errorMessage = 'Error updating Interpersonal Skill info';
    }

    showDialog(
      context:
          parentContext, // Use the parent context instead of the current context
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Theme(
                data: AdminViewDialogStyles.dialogThemeData,
                child: AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  contentPadding: AdminViewDialogStyles.contentPadding,
                  content: Form(
                      key: formKey,
                      child: SizedBox(
                        width: AdminViewDialogStyles.showDialogWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(),
                            Text('* indicates required field',
                                style:
                                    AdminViewDialogStyles.indicatesTextStyle),
                            AdminViewDialogStyles.spacer,
                            const Text('Name*', textAlign: TextAlign.left),
                            AdminViewDialogStyles.interTitleField,
                            TextFormField(
                              style: AdminViewDialogStyles.inputTextStyle,
                              initialValue: iskill.name,
                              decoration: AdminViewDialogStyles.inputDecoration,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                iskill.name = value;
                              },
                            ),
                            AdminViewDialogStyles.spacer,
                            const Divider(),
                          ],
                        ),
                      )),
                  actions: <Widget>[
                    Padding(
                      padding: AdminViewDialogStyles.actionPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: AdminViewDialogStyles.elevatedButtonStyle,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                bool isSuccess = await onISkillUpdated(iskill);
                                if (isSuccess) {
                                  ScaffoldMessenger.of(parentContext)
                                      .showSnackBar(
                                    SnackBar(content: Text(successMessage)),
                                  );
                                } else {
                                  ScaffoldMessenger.of(parentContext)
                                      .showSnackBar(
                                    SnackBar(content: Text(errorMessage)),
                                  );
                                }
                                Navigator.of(dialogContext)
                                    .pop(); // Close update dialog
                                Navigator.of(parentContext)
                                    .pop(); // Close old list
                                _showList(parentContext); // Show new list
                              }
                            },
                            child: Text('Save',
                                style: AdminViewDialogStyles.buttonTextStyle),
                          ),
                          TextButton(
                            style: AdminViewDialogStyles.textButtonStyle,
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: Text('Cancel',
                                style: AdminViewDialogStyles.buttonTextStyle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, List<ISkill> skills, int index) async {
    final name = skills[index].name ?? 'Interpersonal Skill';

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Theme(
              data: AdminViewDialogStyles.dialogThemeData,
              child: Theme(
                data: AdminViewDialogStyles.dialogThemeData,
                child: AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delete \'$name\'?'),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Are you sure you want to delete info for \'$name\'?'),
                    ],
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: AdminViewDialogStyles.actionPadding,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: AdminViewDialogStyles.elevatedButtonStyle,
                              onPressed: () async {
                                final deleted = await _adminController.deleteData(skills, index);
                                if (deleted) {
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('$name deleted successfully')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to delete $name')),
                                  );
                                }
                                Navigator.of(dialogContext).pop(); // Close delete
                                Navigator.of(parentContext).pop(); // Close old list
                                _showList(parentContext); // Show new list dialog
                              },
                              child: Text('Delete',
                                  style: AdminViewDialogStyles.buttonTextStyle),
                            ),
                            TextButton(
                              style: AdminViewDialogStyles.textButtonStyle,
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text('Cancel',
                                  style: AdminViewDialogStyles.buttonTextStyle),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
