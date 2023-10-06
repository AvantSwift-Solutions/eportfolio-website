// ignore_for_file: use_build_context_synchronously

import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:avantswift_portfolio/controllers/analytic_controller.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/iskill_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/ISkill.dart';
import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart';

class ISkillSectionAdmin extends StatefulWidget {
  const ISkillSectionAdmin({super.key});
  @override
  State<ISkillSectionAdmin> createState() => _ISkillSectionAdminState();
}

class _ISkillSectionAdminState extends State<ISkillSectionAdmin> {
  late ISkillSectionAdminController _adminController;
  late List<ISkill> iskills;
  late BuildContext parentContext;

  @override
  void initState() {
    super.initState();
    _adminController = ISkillSectionAdminController(ISkillRepoService());
    _loadItems();
  }

  Future<void> _loadItems() async {
    iskills = await _adminController.getSectionData() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    return ElevatedButton(
        onPressed: () {
          _showList(context);
        },
        style: AdminViewDialogStyles.editSectionButtonStyle
            .copyWith(backgroundColor: AdminViewDialogStyles.eduSkillsColor),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Interpersonal Skills'),
        ));
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
                            ? const Text('Edit Interpersonal Skills        ')
                            : const Text('Edit Interpersonal Skills'),
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
                      iskills.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AdminViewDialogStyles.listSpacing),
                              child: Text('No Interpersonal Skills available'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: iskills.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          AdminViewDialogStyles.listSpacing),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text(iskills[index].name ?? '',
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
                                                context, iskills[index]);
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
    final iskill = ISkill(
      creationTimestamp: Timestamp.now(),
      isid: id,
      index: iskills.length,
      name: '',
    );

    _showISkillDialog(context, iskill, (a) async {
      iskills.add(iskill);
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) {
    final iskill = iskills[i];

    _showISkillDialog(context, iskill, (a) async {
      return await a.update() ?? false;
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
      title = 'Edit ${iskill.name}';
      successMessage = 'Interpersonal Skill info updated successfully';
      errorMessage = 'Error updating Interpersonal Skill info';
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
                                    const Text('Skill Name*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: iskill.name,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a skill name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        iskill.name = value;
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
                                    await AnalyticController.wasEdited(AnalyticRepoService());
                                    setState(() {});
                                    formKey.currentState!.save();
                                    iskill.creationTimestamp = Timestamp.now();
                                    bool isSuccess =
                                        await onISkillUpdated(iskill);
                                    if (!mounted) return;
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

  void _showDeleteDialog(BuildContext context, ISkill x) {
    final name = x.name ?? 'Interpersonal Skill';

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
                      FittedBox(child: Text('Delete $name?')),
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
                                  await AnalyticController.wasEdited(AnalyticRepoService());
                                  iskills.remove(x);
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('$name deleted successfully')),
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
