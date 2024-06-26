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
import 'package:avantswift_portfolio/controllers/admin_controllers/experience_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/Experience.dart';
import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';

class ExperienceSectionAdmin extends StatefulWidget {
  const ExperienceSectionAdmin({super.key});
  @override
  State<ExperienceSectionAdmin> createState() => ExperienceSectionAdminState();
}

class ExperienceSectionAdminState extends State<ExperienceSectionAdmin> {
  late ExperienceSectionAdminController _adminController;
  late List<Experience> experiences;
  late BuildContext parentContext;

  @override
  void initState() {
    super.initState();
    _adminController =
        ExperienceSectionAdminController(ExperienceRepoService());
    _loadItems();
  }

  Future<void> _loadItems() async {
    experiences = await _adminController.getSectionData() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    return ElevatedButton(
      onPressed: () {
        _showList(context);
      },
      style: AdminViewDialogStyles.editSectionButtonStyle.copyWith(
          alignment: Alignment.center,
          backgroundColor: AdminViewDialogStyles.expColor),
      child: const FittedBox(
        fit: BoxFit.fill,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Professional\nExperiences\n'),
            Row(
              children: [
                Icon(
                  Icons.work,
                ),
                Icon(
                  Icons.business,
                ),
                Icon(
                  Icons.assignment_ind,
                ),
                Icon(
                  Icons.computer,
                ),
              ],
            )
          ],
        ),
      ),
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
                        const Text('Edit Professional Experiences'),
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
                      experiences.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AdminViewDialogStyles.listSpacing),
                              child:
                                  Text('No Professional Experiences available'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: experiences.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          AdminViewDialogStyles.listSpacing),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text(
                                        '${experiences[index].jobTitle} at ${experiences[index].companyName}',
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
    final experience = Experience(
      creationTimestamp: Timestamp.now(),
      peid: id,
      index: experiences.length,
      jobTitle: '',
      employmentType: '',
      companyName: '',
      location: '',
      startDate: Timestamp.now(),
      endDate: null,
      description: '',
      logoURL: '',
    );

    _showExperienceDialog(context, experience, (a) async {
      experiences.add(experience);
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) {
    final experience = experiences[i];

    _showExperienceDialog(context, experience, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showExperienceDialog(BuildContext context, Experience experience,
      Future<bool> Function(Experience) onExperienceUpdated) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Uint8List? pickedImageBytes;
    String initialEmploymentType = experience.employmentType ?? 'None';

    TextEditingController startDateController = TextEditingController(
        text: DateFormat('MMMM, y').format(experience.startDate!.toDate()));

    bool currentRole = experience.endDate == null;
    String endDateDisp;
    if (experience.endDate == null) {
      endDateDisp = '-';
    } else {
      endDateDisp = DateFormat('MMMM, y').format(experience.endDate!.toDate());
    }
    TextEditingController endDateController =
        TextEditingController(text: endDateDisp);

    String title, successMessage, errorMessage;
    if (experience.companyName == '') {
      title = 'Add New Professional Experience';
      successMessage = 'Professional Experience info added successfully';
      errorMessage = 'Error adding new Professional Experience info';
    } else {
      title = 'Edit ${experience.jobTitle} at ${experience.companyName}';
      successMessage = 'Professional Experience info updated successfully';
      errorMessage = 'Error updating Professional Experience info';
    }

    final employmentTypes = <String>[
      '',
      'Full-time',
      'Part-time',
      'Contract',
      'Internship',
      'Freelance',
      'Temporary',
      'Volunteer',
    ];

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
                                    const Text('Job Title*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: experience.jobTitle,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a job title';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        experience.jobTitle = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Employment Type',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    DropdownButtonFormField<String>(
                                      value: initialEmploymentType,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onChanged: (value) {
                                        setState(() {
                                          experience.employmentType = value!;
                                        });
                                      },
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      items: employmentTypes
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                        ..add(
                                          const DropdownMenuItem<String>(
                                            value: 'Other',
                                            child: Row(
                                              children: [
                                                Icon(Icons.add),
                                                SizedBox(
                                                    width: AdminViewDialogStyles
                                                        .listSpacing),
                                                Text('Other'),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ),
                                    if (!employmentTypes
                                        .contains(experience.employmentType))
                                      AdminViewDialogStyles.spacer,
                                    if (!employmentTypes
                                        .contains(experience.employmentType))
                                      TextFormField(
                                        decoration: AdminViewDialogStyles
                                            .otherDecoration,
                                        style: AdminViewDialogStyles
                                            .inputTextStyle,
                                        maxLength: AdminViewDialogStyles
                                            .maxFieldLength,
                                        initialValue: experience.employmentType,
                                        onChanged: (value) {
                                          setState(() {
                                            experience.employmentType = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a custom employment type';
                                          }
                                          return null;
                                        },
                                      ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Company Name*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: experience.companyName,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
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
                                    const Text('Location',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: experience.location,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        experience.location = value;
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
                                              experience.startDate!.toDate(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2200),
                                        );
                                        if (pickedDate != null) {
                                          final formattedDate =
                                              DateFormat('MMMM, y')
                                                  .format(pickedDate);
                                          startDateController.text =
                                              formattedDate;
                                          experience.startDate =
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
                                              experience.endDate!.toDate(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2200),
                                        );
                                        if (pickedDate != null) {
                                          final formattedDate =
                                              DateFormat('MMMM, y')
                                                  .format(pickedDate);
                                          endDateController.text =
                                              formattedDate;
                                          experience.endDate =
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
                                                experience.endDate = null;
                                                endDateController.text = '-';
                                              } else {
                                                experience.endDate =
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
                                      initialValue: experience.description,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        experience.description = value;
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
                                    const Text('Company Logo',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    if (pickedImageBytes != null)
                                      Image.memory(pickedImageBytes!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    if (experience.logoURL != '' &&
                                        pickedImageBytes == null)
                                      Image.network(experience.logoURL!,
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
                                              experience.logoURL == ''
                                                  ? 'Add'
                                                  : 'Change',
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
                                      experience.creationTimestamp =
                                          Timestamp.now();
                                      if (pickedImageBytes != null) {
                                        String? imageURL =
                                            await UploadImageAdminController()
                                                .uploadImageAndGetURL(
                                                    pickedImageBytes!,
                                                    '${experience.peid}_image.jpg');
                                        if (imageURL != null) {
                                          experience.logoURL = imageURL;
                                        }
                                      }
                                      bool isSuccess =
                                          await onExperienceUpdated(experience);
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
                                      experience.creationTimestamp =
                                          Timestamp.now();
                                      if (pickedImageBytes != null) {
                                        String? imageURL =
                                            await UploadImageAdminController()
                                                .uploadImageAndGetURL(
                                                    pickedImageBytes!,
                                                    '${experience.peid}_image.jpg');
                                        if (imageURL != null) {
                                          experience.logoURL = imageURL;
                                        }
                                      }
                                      bool isSuccess =
                                          await onExperienceUpdated(experience);
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

  void _showDeleteDialog(BuildContext context, Experience x) async {
    final name = '${x.jobTitle} at ${x.companyName}';

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
                                  await _loadItems();
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
                                  await _loadItems();
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
