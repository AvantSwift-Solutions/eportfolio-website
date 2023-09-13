// ignore_for_file: use_build_context_synchronously
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/experience_section_admin_controller.dart';
import '../models/Experience.dart';
import '../reposervice/experience_repo_services.dart';

class ExperienceSectionAdmin extends StatelessWidget {
  final ExperienceSectionAdminController _adminController =
      ExperienceSectionAdminController(ExperienceRepoService());
  late final BuildContext parentContext;

  ExperienceSectionAdmin({super.key});

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
              child: const Text('Edit Professional Experience Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<Experience> experiences = await _adminController.getSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Theme(
          data: AdminViewDialogStyles.dialogThemeData,
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit Professional Experiences'),
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
                  experiences.isEmpty
                      ? const Text('No Professional Experiences available')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: experiences.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                tileColor: Colors.white,
                                title: Text(experiences[index].companyName!,
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
                                            context, experiences[index]);
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
                    ElevatedButton(
                      style: AdminViewDialogStyles.elevatedButtonStyle,
                      onPressed: () {
                        _showAddNewDialog(context, experiences);
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

  void _showAddNewDialog(BuildContext context, List<Experience> experienceList) async {
    final id = const Uuid().v4();
    final experience = Experience(
      peid: id,
      jobTitle: '',
      companyName: '',
      location: '',
      startDate: Timestamp.now(),
      endDate: Timestamp.now(),
      description: '',
    );

    _showExperienceDialog(context, experience, (a) async {
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final experienceSectionData = await _adminController.getSectionData();
    final experience = experienceSectionData![i];

    _showExperienceDialog(context, experience, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showExperienceDialog(BuildContext context, Experience experience,
      Future<bool> Function(Experience) onExperienceUpdated) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String title, successMessage, errorMessage;
    if (experience.companyName == '') {
      title = 'Add New Professional Experience';
      successMessage = 'Professional Experience info added successfully';
      errorMessage = 'Error adding new Professional Experience info';
    } else {
      title = 'Edit info for \'${experience.companyName}\'';
      successMessage = 'Professional Experience info updated successfully';
      errorMessage = 'Error updating Professional Experience info';
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
                            const Text('Company Name*', textAlign: TextAlign.left),
                            AdminViewDialogStyles.interTitleField,
                            TextFormField(
                              style: AdminViewDialogStyles.inputTextStyle,
                              initialValue: experience.companyName,
                              decoration: AdminViewDialogStyles.inputDecoration,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a company name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                experience.companyName = value;
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
                                bool isSuccess = await onExperienceUpdated(experience);
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

  void _showDeleteDialog(BuildContext context, Experience exp) async {
    final name = exp.companyName ?? 'Professional Experience';

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
                                final deleted = await exp.delete();
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
                                Navigator.of(dialogContext)
                                    .pop(); // Close delete dialog
                                Navigator.of(parentContext)
                                    .pop(); // Close old list dialog
                                _showList(
                                    parentContext); // Show new list dialog
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
