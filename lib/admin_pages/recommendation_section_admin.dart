import 'dart:typed_data';
import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/upload_image_admin_controller.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/recommendation_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/Recommendation.dart';
import 'package:avantswift_portfolio/reposervice/recommendation_repo_services.dart';

class RecommendationSectionAdmin extends StatefulWidget {
  const RecommendationSectionAdmin({super.key});
  @override
  State<RecommendationSectionAdmin> createState() =>
      _RecommendationSectionAdminState();
}

class _RecommendationSectionAdminState
    extends State<RecommendationSectionAdmin> {
  late RecommendationSectionAdminController _adminController;
  late List<Recommendation> recommendations;
  late final BuildContext parentContext;

  @override
  void initState() {
    super.initState();
    _adminController =
        RecommendationSectionAdminController(RecommendationRepoService());
    _loadItems();
  }

  Future<void> _loadItems() async {
    recommendations = await _adminController.getSectionData() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    parentContext = context;
    return ElevatedButton(
        onPressed: () {
          _showList(context);
        },
        style: AdminViewDialogStyles.editSectionButtonStyle
            .copyWith(backgroundColor: AdminViewDialogStyles.recACColor),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Peer\nRecommendations'),
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
                        const Text('Edit Peer Recommendations'),
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
                      recommendations.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AdminViewDialogStyles.listSpacing),
                              child:
                                  Text('No Award & Certifications available'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: recommendations.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          AdminViewDialogStyles.listSpacing),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text(
                                        'Recommendation from ${recommendations[index].colleagueName}',
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
                                            _showDeleteDialog(context,
                                                recommendations[index]);
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
                              _showAddNewDialog(context);
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

  void _showAddNewDialog(BuildContext context) {
    final id = const Uuid().v4();
    final recommendation = Recommendation(
      creationTimestamp: Timestamp.now(),
      rid: id,
      index: recommendations.length,
      colleagueName: '',
      colleagueJobTitle: '',
      description: '',
      imageURL: '',
      dateReceived: null,
    );

    _showRecommendationDialog(context, recommendation, (a) async {
      recommendations.add(recommendation);
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) {
    final recommendation = recommendations[i];

    _showRecommendationDialog(context, recommendation, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showRecommendationDialog(
      BuildContext context,
      Recommendation recommendation,
      Future<bool> Function(Recommendation) onRecommendationUpdated) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Uint8List? pickedImageBytes;

    bool currentRole = recommendation.dateReceived == null;
    String endDateDisp;
    if (recommendation.dateReceived == null) {
      endDateDisp = '-';
    } else {
      endDateDisp =
          DateFormat('MMMM, y').format(recommendation.dateReceived!.toDate());
    }
    TextEditingController dateController =
        TextEditingController(text: endDateDisp);

    String title, successMessage, errorMessage;
    if (recommendation.colleagueName == '') {
      title = 'Add New Recommendation';
      successMessage = 'Recommendation info added successfully';
      errorMessage = 'Error adding new Recommendation info';
    } else {
      title = 'Edit Recommendation from ${recommendation.colleagueName}';
      successMessage = 'Recommendation info updated successfully';
      errorMessage = 'Error updating Recommendation info';
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
                                    const Text('Colleague Name*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue:
                                          recommendation.colleagueName,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        recommendation.colleagueName = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Colleague Job Title',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue:
                                          recommendation.colleagueJobTitle,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      onSaved: (value) {
                                        recommendation.colleagueJobTitle =
                                            value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Date Issued',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      readOnly: true,
                                      decoration:
                                          AdminViewDialogStyles.dateDecoration,
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      controller: dateController,
                                      enabled: !currentRole,
                                      onTap: () async {
                                        final pickedDate =
                                            await showMonthPicker(
                                          context: context,
                                          initialDate: recommendation
                                              .dateReceived!
                                              .toDate(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2200),
                                        );
                                        if (pickedDate != null) {
                                          final formattedDate =
                                              DateFormat('MMMM, y')
                                                  .format(pickedDate);
                                          dateController.text = formattedDate;
                                          recommendation.dateReceived =
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
                                                recommendation.dateReceived =
                                                    null;
                                                dateController.text = '-';
                                              } else {
                                                recommendation.dateReceived =
                                                    Timestamp.now();
                                                dateController.text =
                                                    DateFormat('MMMM, y')
                                                        .format(DateTime.now());
                                              }
                                              currentRole = value!;
                                            });
                                          },
                                        ),
                                        Text('No date associated',
                                            style: AdminViewDialogStyles
                                                .inputTextStyle)
                                      ],
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Recommendation Description*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      maxLines:
                                          AdminViewDialogStyles.textBoxLines,
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: recommendation.description,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a recommendation description';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        recommendation.description = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Image',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    if (pickedImageBytes != null)
                                      Image.memory(pickedImageBytes!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    if (recommendation.imageURL != '' &&
                                        pickedImageBytes == null)
                                      Image.network(recommendation.imageURL!,
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
                                              recommendation.imageURL == ''
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
                                    formKey.currentState!.save();
                                    recommendation.creationTimestamp =
                                        Timestamp.now();
                                    if (pickedImageBytes != null) {
                                      String? imageURL =
                                          await UploadImageAdminController()
                                              .uploadImageAndGetURL(
                                                  pickedImageBytes!,
                                                  '${recommendation.rid}_image.jpg');
                                      if (imageURL != null) {
                                        recommendation.imageURL = imageURL;
                                      }
                                    }
                                    bool isSuccess =
                                        await onRecommendationUpdated(
                                            recommendation);
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

  void _showDeleteDialog(BuildContext context, Recommendation x) {
    final name = 'Recommendation from ${x.colleagueName}';

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
                                  recommendations.remove(x);
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
