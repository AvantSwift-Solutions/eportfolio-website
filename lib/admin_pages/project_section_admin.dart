// ignore_for_file: use_build_context_synchronously
import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/project_section_admin_controller.dart';
import '../models/Project.dart';
import '../reposervice/project_repo_services.dart';

class ProjectSectionAdmin extends StatelessWidget {
  final ProjectSectionAdminController _adminController =
      ProjectSectionAdminController(ProjectRepoService());
  late final BuildContext parentContext;

  ProjectSectionAdmin({super.key});

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
              child: const Text('Edit Personal Project Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<Project> projects = await _adminController.getSectionData() ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Theme(
          data: AdminViewDialogStyles.dialogThemeData,
          child: AlertDialog(
            scrollable: true,
            titlePadding: AdminViewDialogStyles.titleDialogPadding,
            contentPadding: AdminViewDialogStyles.contentDialogPadding,
            actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
            title: Container(
                padding: AdminViewDialogStyles.titleContPadding,
                color: AdminViewDialogStyles.bgColor,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Edit Personal Projects'),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            iconSize: AdminViewDialogStyles.closeIconSize,
                            hoverColor: Colors.transparent,
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                )),
            content: SizedBox(
              height: AdminViewDialogStyles.listDialogHeight,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: AdminViewDialogStyles.listDialogWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      projects.isEmpty
                          ? const Text('No Personal Projects available')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: projects.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          AdminViewDialogStyles.listSpacing),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text(projects[index].name ?? '',
                                        style: AdminViewDialogStyles
                                            .listTextStyle),
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
                                                context, projects[index]);
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
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Container(
                  padding: AdminViewDialogStyles.actionsContPadding,
                  color: AdminViewDialogStyles.bgColor,
                  child: Column(
                    children: [
                      const Divider(),
                      const SizedBox(height: AdminViewDialogStyles.listSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReorderDialog(
                            controller: _adminController,
                            onReorder: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.of(parentContext).pop();
                              _showList(parentContext);
                            },
                          ),
                          ElevatedButton(
                            style: AdminViewDialogStyles.elevatedButtonStyle,
                            onPressed: () {
                              _showAddNewDialog(context, projects);
                            },
                            child: Text(
                              'Add New',
                              style: AdminViewDialogStyles.buttonTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        );
      },
    );
  }

  void _showAddNewDialog(
      BuildContext context, List<Project> projectList) async {
    final id = const Uuid().v4();
    final project = Project(
      creationTimestamp: Timestamp.now(),
      ppid: id,
      index: projectList.length,
      name: '',
      link: '',
      description: '',
    );

    _showProjectDialog(context, project, (a) async {
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final projectSectionData = await _adminController.getSectionData();
    final project = projectSectionData![i];

    _showProjectDialog(context, project, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showProjectDialog(BuildContext context, Project project,
      Future<bool> Function(Project) onProjectUpdated) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String title, successMessage, errorMessage;
    if (project.name == '') {
      title = 'Add New Personal Project';
      successMessage = 'Personal Project info added successfully';
      errorMessage = 'Error adding new Personal Project info';
    } else {
      title = 'Edit info for \'${project.name}\'';
      successMessage = 'Personal Project info updated successfully';
      errorMessage = 'Error updating Personal Project info';
    }

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Theme(
                data: AdminViewDialogStyles.dialogThemeData,
                child: AlertDialog(
                  scrollable: true,
                  titlePadding: AdminViewDialogStyles.titleDialogPadding,
                  contentPadding: AdminViewDialogStyles.contentDialogPadding,
                  actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
                  title: Container(
                      padding: AdminViewDialogStyles.titleContPadding,
                      color: AdminViewDialogStyles.bgColor,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  iconSize: AdminViewDialogStyles.closeIconSize,
                                  hoverColor: Colors.transparent,
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     '* indicates required field',
                          //     style: AdminViewDialogStyles.indicatesTextStyle,
                          //   ),
                          // ),
                        ],
                      )),
                  content: SizedBox(
                      height: AdminViewDialogStyles.showDialogHeight,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: AdminViewDialogStyles.showDialogWidth,
                          child: Form(
                              key: formKey,
                              child: SizedBox(
                                width: AdminViewDialogStyles.showDialogWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '* indicates required field',
                                      style: AdminViewDialogStyles
                                          .indicatesTextStyle,
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Project Name*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: project.name,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a project name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        project.name = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Description',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      maxLines:
                                          AdminViewDialogStyles.textBoxLines,
                                      maxLength:
                                          AdminViewDialogStyles.maxDescLength,
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: project.description,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        project.description = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Project Link',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: project.link,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        project.link = value;
                                      },
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      )),
                  actions: <Widget>[
                    Container(
                      padding: AdminViewDialogStyles.actionsContPadding,
                      color: AdminViewDialogStyles.bgColor,
                      child: Column(
                        children: [
                          const Divider(),
                          const SizedBox(
                              height: AdminViewDialogStyles.listSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style:
                                    AdminViewDialogStyles.elevatedButtonStyle,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    project.creationTimestamp = Timestamp.now();
                                    bool isSuccess =
                                        await onProjectUpdated(project);
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
                                    Navigator.of(dialogContext).pop();
                                    Navigator.of(parentContext).pop();
                                    _showList(parentContext); // Show new list
                                  }
                                },
                                child: Text('Save',
                                    style:
                                        AdminViewDialogStyles.buttonTextStyle),
                              ),
                              TextButton(
                                style: AdminViewDialogStyles.textButtonStyle,
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                child: Text('Cancel',
                                    style:
                                        AdminViewDialogStyles.buttonTextStyle),
                              ),
                            ],
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

  void _showDeleteDialog(BuildContext context, Project x) async {
    final name = x.name ?? 'Personal Project';

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
                          iconSize: AdminViewDialogStyles.closeIconSize,
                          hoverColor: Colors.transparent,
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
                      padding: AdminViewDialogStyles.deleteActionsDialogPadding,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: AdminViewDialogStyles.elevatedButtonStyle,
                              onPressed: () async {
                                final deleted = await x.delete() ?? false;
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
                                Navigator.of(dialogContext).pop();
                                Navigator.of(parentContext).pop();
                                _showList(parentContext);
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
