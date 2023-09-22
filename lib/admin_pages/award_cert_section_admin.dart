// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:avantswift_portfolio/admin_pages/reorder_dialog.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:uuid/uuid.dart';
import '../controllers/admin_controllers/award_cert_section_admin_controller.dart';
import '../models/AwardCert.dart';
import '../reposervice/award_cert_repo_services.dart';

class AwardCertSectionAdmin extends StatelessWidget {
  final AwardCertSectionAdminController _adminController =
      AwardCertSectionAdminController(AwardCertRepoService());
  late final BuildContext parentContext;

  AwardCertSectionAdmin({super.key});

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
              child: const Text('Edit Award & Certification Info'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    List<AwardCert> awardcerts = await _adminController.getSectionData() ?? [];
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Edit Award & Certifications'),
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
                      awardcerts.isEmpty
                          ? const Text('No Award & Certifications available')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: awardcerts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical:
                                          AdminViewDialogStyles.listSpacing),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text(
                                        '${awardcerts[index].name} from ${awardcerts[index].source}',
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
                                                context, awardcerts[index]);
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
                              _showAddNewDialog(context, awardcerts);
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
      BuildContext context, List<AwardCert> awardcertList) async {
    final id = const Uuid().v4();
    final awardcert = AwardCert(
      creationTimestamp: Timestamp.now(),
      acid: id,
      index: awardcertList.length,
      name: '',
      link: '',
      source: '',
      imageURL: '',
      dateIssued: null,
    );

    _showAwardCertDialog(context, awardcert, (a) async {
      return await a.create(id);
    });
  }

  void _showEditDialog(BuildContext context, int i) async {
    final awardcertSectionData = await _adminController.getSectionData();
    final awardcert = awardcertSectionData![i];

    _showAwardCertDialog(context, awardcert, (a) async {
      return await a.update() ?? false;
    });
  }

  void _showAwardCertDialog(BuildContext context, AwardCert awardcert,
      Future<bool> Function(AwardCert) onAwardCertUpdated) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Uint8List? pickedImageBytes;

    bool currentRole = awardcert.dateIssued == null;
    String endDateDisp;
    if (awardcert.dateIssued == null) {
      endDateDisp = '-';
    } else {
      endDateDisp =
          DateFormat('MMMM, y').format(awardcert.dateIssued!.toDate());
    }
    TextEditingController dateController =
        TextEditingController(text: endDateDisp);

    String title, successMessage, errorMessage;
    if (awardcert.name == '') {
      title = 'Add New Award & Certification';
      successMessage = 'Award & Certification info added successfully';
      errorMessage = 'Error adding new Award & Certification info';
    } else {
      title = 'Edit info for \'${awardcert.name} from ${awardcert.source}\'';
      successMessage = 'Award & Certification info updated successfully';
      errorMessage = 'Error updating Award & Certification info';
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
                                    const Text('Award/Certificate Name*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: awardcert.name,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        awardcert.name = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Source*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: awardcert.source,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a source';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        awardcert.source = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Link',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: awardcert.link,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value != null &&
                                            value.isNotEmpty &&
                                            !Uri.parse(value).isAbsolute) {
                                          return 'Please enter a valid link';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        awardcert.link = value;
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
                                          initialDate:
                                              awardcert.dateIssued!.toDate(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2200),
                                        );
                                        if (pickedDate != null) {
                                          final formattedDate =
                                              DateFormat('MMMM, y')
                                                  .format(pickedDate);
                                          dateController.text = formattedDate;
                                          awardcert.dateIssued =
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
                                                awardcert.dateIssued = null;
                                                dateController.text = '-';
                                              } else {
                                                awardcert.dateIssued =
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
                                    const Text('Image',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    if (pickedImageBytes != null)
                                      Image.memory(pickedImageBytes!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    if (awardcert.imageURL != '' &&
                                        pickedImageBytes == null)
                                      Image.network(awardcert.imageURL!,
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
                                              awardcert.imageURL == ''
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
                                    awardcert.creationTimestamp =
                                        Timestamp.now();
                                    if (pickedImageBytes != null) {
                                      String? imageURL = await _adminController
                                          .uploadImageAndGetURL(
                                              pickedImageBytes!,
                                              '${awardcert.acid}_image.jpg');
                                      if (imageURL != null) {
                                        awardcert.imageURL = imageURL;
                                      }
                                    }
                                    bool isSuccess =
                                        await onAwardCertUpdated(awardcert);
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

  void _showDeleteDialog(BuildContext context, AwardCert x) async {
    final name = '${x.name} from ${x.source}';

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
