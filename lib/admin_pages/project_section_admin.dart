// ignore_for_file: use_build_context_synchronously

import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:avantswift_portfolio/controllers/analytic_controller.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/project_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/Project.dart';
import 'package:avantswift_portfolio/reposervice/project_repo_services.dart';

class ProjectSectionAdmin extends StatefulWidget {
  const ProjectSectionAdmin({super.key});
  @override
  State<ProjectSectionAdmin> createState() => _ProjectSectionAdminState();
}

class _ProjectSectionAdminState extends State<ProjectSectionAdmin> {
  late ProjectSectionAdminController _adminController;
  late List<Project> projects;
  late BuildContext parentContext;
  late String sectionDesc;

  @override
  void initState() {
    super.initState();
    _adminController = ProjectSectionAdminController(ProjectRepoService());
    _loadItems();
  }

  Future<void> _loadItems() async {
    projects = await _adminController.getSectionData() ?? [];
    sectionDesc = await _adminController.getSectionDescription();
  }

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    return ElevatedButton(
        onPressed: () {
          _showList(context);
        },
        style: AdminViewDialogStyles.editSectionButtonStyle
            .copyWith(backgroundColor: AdminViewDialogStyles.projColor),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Personal Projects'),
        ));
  }

  void _editSectionDescription(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Theme(
                data: AdminViewDialogStyles.dialogThemeData,
                child: AlertDialog(
                  titlePadding: AdminViewDialogStyles.titleDialogPadding,
                  contentPadding: AdminViewDialogStyles.contentDialogPadding,
                  actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
                  title: Container(
                      padding: AdminViewDialogStyles.titleContPadding,
                      color: AdminViewDialogStyles.bgColor,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text('Edit Section Description'),
                          ),
                          Divider()
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
                                    AdminViewDialogStyles.spacer,
                                    const Text('Section Description',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      maxLines:
                                          AdminViewDialogStyles.textBoxLines,
                                      maxLength:
                                          AdminViewDialogStyles.maxDescLength,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.none,
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: sectionDesc,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        _adminController
                                            .updateSectionDescription(value);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a description';
                                        } else if (value.isNotEmpty &&
                                            value.length >
                                                AdminViewDialogStyles
                                                    .maxDescLength) {
                                          return 'Please reduce the length of the description';
                                        }
                                        return null;
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Divider(),
                          const SizedBox(
                              height: AdminViewDialogStyles.listSpacing),
                          if (MediaQuery.of(context).size.width >=
                              AdminViewDialogStyles.fitOptionsThreshold)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style:
                                      AdminViewDialogStyles.elevatedButtonStyle,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await AnalyticController.wasEdited(
                                          AnalyticRepoService());
                                      formKey.currentState!.save();
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(parentContext)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Section Description updated')),
                                      );
                                      Navigator.of(dialogContext).pop();
                                      Navigator.of(parentContext).pop();
                                      _showList(parentContext); // Show new list
                                    }
                                  },
                                  child: Text('Save',
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
                                ),
                                TextButton(
                                  style: AdminViewDialogStyles.textButtonStyle,
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Text('Cancel',
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
                                ),
                              ],
                            ),
                          if (MediaQuery.of(context).size.width <
                              AdminViewDialogStyles.fitOptionsThreshold)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style:
                                      AdminViewDialogStyles.elevatedButtonStyle,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await AnalyticController.wasEdited(
                                          AnalyticRepoService());
                                      formKey.currentState!.save();
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(parentContext)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Section Description updated')),
                                      );
                                      Navigator.of(dialogContext).pop();
                                      Navigator.of(parentContext).pop();
                                      _showList(parentContext); // Show new list
                                    }
                                  },
                                  child: Text('Save',
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
                                ),
                                TextButton(
                                  style: AdminViewDialogStyles.textButtonStyle,
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Text('Cancel',
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
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

  void _showList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Theme(
          data: AdminViewDialogStyles.dialogThemeData,
          child: AlertDialog(
            titlePadding: AdminViewDialogStyles.titleDialogPadding,
            contentPadding: AdminViewDialogStyles.contentDialogPadding,
            actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
            title: Container(
                padding: AdminViewDialogStyles.titleContPadding,
                color: AdminViewDialogStyles.bgColor,
                child: Column(
                  children: [
                    FittedBox(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MediaQuery.of(context).size.width >
                                AdminViewDialogStyles.showDialogWidth
                            ? const Text('Edit Personal Projects          ')
                            : const Text('Edit Personal Projects'),
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
                    )),
                    const Divider()
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
                      SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            child: ElevatedButton(
                                style: AdminViewDialogStyles
                                    .centerImageButtonStyle,
                                onPressed: () {
                                  _editSectionDescription(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 30),
                                    Text('Edit Section Description ',
                                        style: AdminViewDialogStyles
                                            .buttonTextStyle),
                                    const Icon(Icons.edit),
                                    const SizedBox(width: 30),
                                  ],
                                )),
                          )),
                      projects.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AdminViewDialogStyles.listSpacing),
                              child: Text('No Personal Projects available'))
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
                      if (MediaQuery.of(context).size.width >
                          AdminViewDialogStyles.fitOptionsThreshold)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReorderDialog(
                              controller: _adminController,
                              onReorder: () async {
                                await _loadItems();
                                Navigator.of(dialogContext).pop();
                                Navigator.of(parentContext).pop();
                                _showList(parentContext);
                              },
                            ),
                            ElevatedButton(
                              style: AdminViewDialogStyles.elevatedButtonStyle,
                              onPressed: () {
                                _showAddNewDialog(context);
                              },
                              child: Text(
                                'Add New',
                                style: AdminViewDialogStyles.buttonTextStyle,
                              ),
                            ),
                          ],
                        ),
                      if (MediaQuery.of(context).size.width <=
                          AdminViewDialogStyles.fitOptionsThreshold)
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ReorderDialog(
                                controller: _adminController,
                                onReorder: () async {
                                  await _loadItems();
                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(parentContext).pop();
                                  _showList(parentContext);
                                },
                              ),
                              AdminViewDialogStyles.reorderOKSpacing,
                              ElevatedButton(
                                style:
                                    AdminViewDialogStyles.elevatedButtonStyle,
                                onPressed: () {
                                  _showAddNewDialog(context);
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
                  ))
            ],
          ),
        );
      },
    );
  }

  void _showAddNewDialog(BuildContext context) {
    final id = const Uuid().v4();
    final project = Project(
      creationTimestamp: Timestamp.now(),
      ppid: id,
      index: projects.length,
      name: '',
      link: '',
      description: '',
    );

    _showProjectDialog(context, project, (a) async {
      projects.add(project);
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) {
    final project = projects[i];

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
      title = 'Edit ${project.name}';
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
                  titlePadding: AdminViewDialogStyles.titleDialogPadding,
                  contentPadding: AdminViewDialogStyles.contentDialogPadding,
                  actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
                  title: Container(
                      padding: AdminViewDialogStyles.titleContPadding,
                      color: AdminViewDialogStyles.bgColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(child: Text(title)),
                          const Divider()
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
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
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
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.none,
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: project.description,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        project.description = value;
                                      },
                                      validator: (value) {
                                        if (value != null &&
                                            value.isNotEmpty &&
                                            value.length >
                                                AdminViewDialogStyles
                                                    .maxDescLength) {
                                          return 'Please reduce the length of the description';
                                        }
                                        return null;
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Divider(),
                          const SizedBox(
                              height: AdminViewDialogStyles.listSpacing),
                          if (MediaQuery.of(context).size.width >=
                              AdminViewDialogStyles.fitOptionsThreshold)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style:
                                      AdminViewDialogStyles.elevatedButtonStyle,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await AnalyticController.wasEdited(
                                          AnalyticRepoService());
                                      formKey.currentState!.save();
                                      project.creationTimestamp =
                                          Timestamp.now();
                                      bool isSuccess =
                                          await onProjectUpdated(project);
                                      if (!mounted) return;
                                      if (isSuccess) {
                                        ScaffoldMessenger.of(parentContext)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(successMessage)),
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
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
                                ),
                                TextButton(
                                  style: AdminViewDialogStyles.textButtonStyle,
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Text('Cancel',
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
                                ),
                              ],
                            ),
                          if (MediaQuery.of(context).size.width <
                              AdminViewDialogStyles.fitOptionsThreshold)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style:
                                      AdminViewDialogStyles.elevatedButtonStyle,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await AnalyticController.wasEdited(
                                          AnalyticRepoService());
                                      formKey.currentState!.save();
                                      project.creationTimestamp =
                                          Timestamp.now();
                                      bool isSuccess =
                                          await onProjectUpdated(project);
                                      if (!mounted) return;
                                      if (isSuccess) {
                                        ScaffoldMessenger.of(parentContext)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(successMessage)),
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
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
                                ),
                                TextButton(
                                  style: AdminViewDialogStyles.textButtonStyle,
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Text('Cancel',
                                      style: AdminViewDialogStyles
                                          .buttonTextStyle),
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

  void _showDeleteDialog(BuildContext context, Project x) {
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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text('Delete $name?'),
                      ),
                      const Divider()
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
                    if (MediaQuery.of(context).size.width >=
                        AdminViewDialogStyles.stackOptionsThreshold)
                      Padding(
                        padding:
                            AdminViewDialogStyles.deleteActionsDialogPadding,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style:
                                    AdminViewDialogStyles.elevatedButtonStyle,
                                onPressed: () async {
                                  final deleted = await x.delete() ?? false;
                                  if (deleted) {
                                    await AnalyticController.wasEdited(
                                        AnalyticRepoService());
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '$name deleted successfully')),
                                    );
                                  } else {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Failed to delete $name')),
                                    );
                                  }
                                  if (!mounted) return;
                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(parentContext).pop();
                                  _showList(parentContext);
                                },
                                child: Text('Delete',
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
                            ]),
                      ),
                    if (MediaQuery.of(context).size.width <
                        AdminViewDialogStyles.stackOptionsThreshold)
                      Padding(
                        padding:
                            AdminViewDialogStyles.deleteActionsDialogPadding,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style:
                                    AdminViewDialogStyles.elevatedButtonStyle,
                                onPressed: () async {
                                  final deleted = await x.delete() ?? false;
                                  if (deleted) {
                                    await AnalyticController.wasEdited(
                                        AnalyticRepoService());
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '$name deleted successfully')),
                                    );
                                  } else {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Failed to delete $name')),
                                    );
                                  }
                                  if (!mounted) return;
                                  Navigator.of(dialogContext).pop();
                                  Navigator.of(parentContext).pop();
                                  _showList(parentContext);
                                },
                                child: Text('Delete',
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
                            ]),
                      ),
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
