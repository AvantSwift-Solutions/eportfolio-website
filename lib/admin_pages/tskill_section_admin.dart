// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/upload_image_admin_controller.dart';
import 'package:avantswift_portfolio/controllers/analytic_controller.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/tskill_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/TSkill.dart';
import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TSkillSectionAdmin extends StatefulWidget {
  const TSkillSectionAdmin({super.key});
  @override
  State<TSkillSectionAdmin> createState() => _TSkillSectionAdminState();
}

class _TSkillSectionAdminState extends State<TSkillSectionAdmin> {
  late TSkillSectionAdminController _adminController;
  late List<TSkill> tskills;
  late BuildContext parentContext;
  late String centerImageURL;

  @override
  void initState() {
    super.initState();
    _adminController = TSkillSectionAdminController(TSkillRepoService());
    _loadItems();
  }

  Future<void> _loadItems() async {
    tskills = await _adminController.getSectionData() ?? [];
    centerImageURL = await FirebaseStorage.instance
        .ref('images/technical_skills_image')
        .getDownloadURL();
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
          child: Text('Technical Skills'),
        ));
  }

  void _editCenterImage(BuildContext context) {
    Uint8List? pickedImageBytes;

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
                            child: Text('Change Center Image'),
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
                              child: SizedBox(
                            width: AdminViewDialogStyles.showDialogWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AdminViewDialogStyles.spacer,
                                if (pickedImageBytes != null)
                                  Image.memory(pickedImageBytes!,
                                      width: AdminViewDialogStyles.imageWidth),
                                if (centerImageURL != '' &&
                                    pickedImageBytes == null)
                                  Image.network(centerImageURL,
                                      width: AdminViewDialogStyles.imageWidth),
                                AdminViewDialogStyles.interTitleField,
                                ElevatedButton(
                                  onPressed: () async {
                                    Uint8List? imageBytes = await _pickImage();
                                    if (imageBytes != null) {
                                      pickedImageBytes = imageBytes;
                                      setState(() {});
                                    }
                                  },
                                  style: AdminViewDialogStyles.imageButtonStyle,
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.add),
                                        Text(
                                          centerImageURL == ''
                                              ? 'Add Image'
                                              : 'Change Image',
                                          style: AdminViewDialogStyles
                                              .buttonTextStyle,
                                        )
                                      ]),
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
                                  if (pickedImageBytes != null) {
                                    await AnalyticController.wasEdited(AnalyticRepoService());
                                    String? imageURL =
                                        await UploadImageAdminController()
                                            .uploadImageAndGetURL(
                                                pickedImageBytes!,
                                                'technical_skills_image');
                                    if (!mounted) return;
                                    if (imageURL != null) {
                                      ScaffoldMessenger.of(parentContext)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Center Image updated successfully')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(parentContext)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Error updating Center Image')),
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
                            ? const Text('Edit Technical Skills              ')
                            : const Text('Edit Technical Skills'),
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
                                  _editCenterImage(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 40),
                                    Text('Edit Center Image ',
                                        style: AdminViewDialogStyles
                                            .buttonTextStyle),
                                    const Icon(Icons.edit),
                                    const SizedBox(width: 40),
                                  ],
                                )),
                          )),
                      tskills.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AdminViewDialogStyles.listSpacing),
                              child: Text('No Technical Skills available'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: tskills.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          AdminViewDialogStyles.listSpacing),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text(tskills[index].name ?? '',
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
                                                context, tskills[index]);
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
    final tskill = TSkill(
      creationTimestamp: Timestamp.now(),
      tsid: id,
      index: tskills.length,
      name: '',
      imageURL: '',
    );

    _showTSkillDialog(context, tskill, (a) async {
      tskills.add(tskill);
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) {
    final tskill = tskills[i];

    _showTSkillDialog(context, tskill, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showTSkillDialog(BuildContext context, TSkill tskill,
      Future<bool> Function(TSkill) onTSkillUpdated) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Uint8List? pickedImageBytes;

    String title, successMessage, errorMessage;
    if (tskill.name == '') {
      title = 'Add New Technical Skill';
      successMessage = 'Technical Skill info added successfully';
      errorMessage = 'Error adding new Technical Skill info';
    } else {
      title = 'Edit ${tskill.name}';
      successMessage = 'Technical Skill info updated successfully';
      errorMessage = 'Error updating Technical Skill info';
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
                                      initialValue: tskill.name,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a skill name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        tskill.name = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Display Image',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    if (pickedImageBytes != null)
                                      Image.memory(pickedImageBytes!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    if (tskill.imageURL != '' &&
                                        pickedImageBytes == null)
                                      Image.network(tskill.imageURL!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    AdminViewDialogStyles.interTitleField,
                                    ElevatedButton(
                                      onPressed: () async {
                                        Uint8List? imageBytes =
                                            await _pickImage();
                                        if (imageBytes != null) {
                                          pickedImageBytes = imageBytes;
                                          setState(() {});
                                        }
                                      },
                                      style: AdminViewDialogStyles
                                          .imageButtonStyle,
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.add),
                                            Text(
                                              tskill.imageURL == ''
                                                  ? 'Add Image'
                                                  : 'Change Image',
                                              style: AdminViewDialogStyles
                                                  .buttonTextStyle,
                                            )
                                          ]),
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
                                    formKey.currentState!.save();
                                    tskill.creationTimestamp = Timestamp.now();
                                    if (pickedImageBytes != null) {
                                      String? imageURL =
                                          await UploadImageAdminController()
                                              .uploadImageAndGetURL(
                                                  pickedImageBytes!,
                                                  '${tskill.tsid}_image.jpg');
                                      if (imageURL != null) {
                                        tskill.imageURL = imageURL;
                                      }
                                    }
                                    bool isSuccess =
                                        await onTSkillUpdated(tskill);
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

  void _showDeleteDialog(BuildContext context, TSkill x) {
    final name = '${x.name}';

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
                                  tskills.remove(x);
                                  setState(() {});
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
