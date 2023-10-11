// ignore_for_file: use_build_context_synchronously

import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/upload_image_admin_controller.dart';
import 'package:avantswift_portfolio/controllers/analytic_controller.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/education_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/Education.dart';
import 'package:avantswift_portfolio/reposervice/education_repo_services.dart';

class EducationSectionAdmin extends StatefulWidget {
  const EducationSectionAdmin({super.key});
  @override
  State<EducationSectionAdmin> createState() => _EducationSectionAdminState();
}

class _EducationSectionAdminState extends State<EducationSectionAdmin> {
  late EducationSectionAdminController _adminController;
  late List<Education> educations;
  late BuildContext parentContext;

  @override
  void initState() {
    super.initState();
    _adminController = EducationSectionAdminController(EducationRepoService());
    _loadItems();
  }

  Future<void> _loadItems() async {
    educations = await _adminController.getSectionData() ?? [];
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
            child: Row(
              children: [
                Text('Education '),
                Icon(Icons.school),
              ],
            )));
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
                            ? const Text(
                                'Edit Education                       ')
                            : const Text('Edit Education'),
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
                      educations.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AdminViewDialogStyles.listSpacing),
                              child: Text('No Educations available'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: educations.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          AdminViewDialogStyles.listSpacing),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text(
                                        '${educations[index].degree} at ${educations[index].schoolName}',
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
                                                context, educations[index]);
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
    final education = Education(
      creationTimestamp: Timestamp.now(),
      eid: id,
      schoolName: '',
      degree: '',
      index: educations.length,
      startDate: Timestamp.now(),
      endDate: null,
      description: '',
      logoURL: '',
      major: '',
      grade: -1,
      gradeDescription: '',
    );

    _showEducationDialog(context, education, (a) async {
      educations.add(education);
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) {
    final education = educations[i];

    _showEducationDialog(context, education, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showEducationDialog(BuildContext context, Education education,
      Future<bool> Function(Education) onEducationUpdated) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Uint8List? pickedImageBytes;

    TextEditingController startDateController = TextEditingController(
        text: DateFormat('MMMM, y').format(education.startDate!.toDate()));

    bool currentRole = education.endDate == null;
    String endDateDisp;
    if (education.endDate == null) {
      endDateDisp = '-';
    } else {
      endDateDisp = DateFormat('MMMM, y').format(education.endDate!.toDate());
    }
    TextEditingController endDateController =
        TextEditingController(text: endDateDisp);

    String title, successMessage, errorMessage;
    if (education.schoolName == '') {
      title = 'Add New Education';
      successMessage = 'Education info added successfully';
      errorMessage = 'Error adding new Education info';
    } else {
      title = 'Edit ${education.degree} at ${education.schoolName}';
      successMessage = 'Education info updated successfully';
      errorMessage = 'Error updating Education info';
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
                                    const Text('School Name*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: education.schoolName,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a school name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        education.schoolName = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Degree*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: education.degree,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a degree';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        education.degree = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Major',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: education.major,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        education.major = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Start Date',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      readOnly: true,
                                      decoration:
                                          AdminViewDialogStyles.dateDecoration,
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      controller: startDateController,
                                      onTap: () async {
                                        final pickedDate =
                                            await showMonthPicker(
                                          context: context,
                                          initialDate:
                                              education.startDate!.toDate(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2200),
                                        );
                                        if (pickedDate != null) {
                                          final formattedDate =
                                              DateFormat('MMMM, y')
                                                  .format(pickedDate);
                                          startDateController.text =
                                              formattedDate;
                                          education.startDate =
                                              Timestamp.fromDate(pickedDate);
                                        }
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('End Date',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      readOnly: true,
                                      decoration:
                                          AdminViewDialogStyles.dateDecoration,
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      controller: endDateController,
                                      enabled: !currentRole,
                                      onTap: () async {
                                        final pickedDate =
                                            await showMonthPicker(
                                          context: context,
                                          initialDate:
                                              education.endDate!.toDate(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2200),
                                        );
                                        if (pickedDate != null) {
                                          final formattedDate =
                                              DateFormat('MMMM, y')
                                                  .format(pickedDate);
                                          endDateController.text =
                                              formattedDate;
                                          education.endDate =
                                              Timestamp.fromDate(pickedDate);
                                        }
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: currentRole,
                                          onChanged: (value) {
                                            setState(() {
                                              if (!currentRole) {
                                                education.endDate = null;
                                                endDateController.text = '-';
                                              } else {
                                                education.endDate =
                                                    Timestamp.now();
                                                endDateController.text =
                                                    DateFormat('MMMM, y')
                                                        .format(DateTime.now());
                                              }
                                              currentRole = value!;
                                            });
                                          },
                                        ),
                                        Text('Current',
                                            style: AdminViewDialogStyles
                                                .inputTextStyle)
                                      ],
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Grade',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: education.grade == -1
                                          ? ''
                                          : education.grade.toString(),
                                      validator: (value) {
                                        if (value != null && value.isNotEmpty) {
                                          if (double.tryParse(value) == null) {
                                            return 'Please enter a valid number';
                                          } else if (double.tryParse(value)! <
                                              0) {
                                            return 'Please enter a positive number';
                                          }
                                        }
                                        return null;
                                      },
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      onSaved: (value) {
                                        education.grade =
                                            double.tryParse(value ?? '-1') ??
                                                -1;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Grade Description',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: education.gradeDescription,
                                      decoration: AdminViewDialogStyles
                                          .inputDecoration
                                          .copyWith(
                                        hintText: 'e.g. First Class Honours',
                                      ),
                                      onSaved: (value) {
                                        education.gradeDescription = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Description',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLines:
                                          AdminViewDialogStyles.textBoxLines,
                                      maxLength:
                                          AdminViewDialogStyles.maxDescLength,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.none,
                                      initialValue: education.description,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        education.description = value;
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
                                    const Text('School Logo',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    if (pickedImageBytes != null)
                                      Image.memory(pickedImageBytes!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    if (education.logoURL != '' &&
                                        pickedImageBytes == null)
                                      Image.network(education.logoURL!,
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
                                              education.logoURL == ''
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
                                    await AnalyticController.wasEdited(
                                        AnalyticRepoService());
                                    formKey.currentState!.save();
                                    education.creationTimestamp =
                                        Timestamp.now();
                                    if (pickedImageBytes != null) {
                                      String? imageURL =
                                          await UploadImageAdminController()
                                              .uploadImageAndGetURL(
                                                  pickedImageBytes!,
                                                  '${education.eid}_image.jpg');
                                      if (imageURL != null) {
                                        education.logoURL = imageURL;
                                      }
                                    }
                                    bool isSuccess =
                                        await onEducationUpdated(education);
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

  void _showDeleteDialog(BuildContext context, Education x) {
    final name = '${x.degree} at ${x.schoolName}';

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
                                  await AnalyticController.wasEdited(
                                      AnalyticRepoService());
                                  educations.remove(x);
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
