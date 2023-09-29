import 'package:avantswift_portfolio/controllers/admin_controllers/upload_image_admin_controller.dart';
import 'package:avantswift_portfolio/dto/landing_page_dto.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/landing_page_admin_controller.dart';

class LandingPageAdmin extends StatefulWidget {
  const LandingPageAdmin({super.key});
  @override
  State<LandingPageAdmin> createState() => _LandingPageAdminState();
}

class _LandingPageAdminState extends State<LandingPageAdmin> {
  late LandingPageAdminController _adminController;
  late LandingPageDTO landingPageData;

  @override
  void initState() {
    super.initState();
    _adminController = LandingPageAdminController(UserRepoService());
    _loadItems();
  }

  Future<void> _loadItems() async {
    landingPageData = await _adminController.getLandingPageData()
        // Should never be null as it is handled in the controller
        ??
        LandingPageDTO(
          name: '',
          nickname: '',
          landingPageDescription: '',
          imageURL: '',
        );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _showEditDialog(context);
        },
        style: AdminViewDialogStyles.editSectionButtonStyle,
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Landing Page'),
        ));
  }

  void _showEditDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Uint8List? pickedImageBytes;
    // Flag to check if user tried to sumbit without picking a required image
    bool noImage = false;

    String title, successMessage, errorMessage;
    title = 'Edit Landing Page info';
    successMessage = 'Landing Page info updated successfully';
    errorMessage = 'Error updating Landing Page info';

    showDialog(
      context: context,
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
                                    const Text('Name*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: landingPageData.name,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        landingPageData.name = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Nickname*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      maxLength:
                                          AdminViewDialogStyles.maxFieldLength,
                                      initialValue: landingPageData.nickname,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a nickname';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        landingPageData.nickname = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Short Description*',
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
                                      initialValue: landingPageData
                                          .landingPageDescription,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
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
                                      onSaved: (value) {
                                        landingPageData.landingPageDescription =
                                            value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('Landing Page Image*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    if (pickedImageBytes != null)
                                      Image.memory(pickedImageBytes!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    if (landingPageData.imageURL != '' &&
                                        pickedImageBytes == null)
                                      Image.network(landingPageData.imageURL!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    AdminViewDialogStyles.interTitleField,
                                    ElevatedButton(
                                      onPressed: () async {
                                        Uint8List? imageBytes =
                                            await _pickImage();
                                        if (imageBytes != null) {
                                          noImage = false;
                                          pickedImageBytes = imageBytes;
                                          setState(() {});
                                        }
                                      },
                                      style: noImage
                                          ? AdminViewDialogStyles
                                              .noImageButtonStyle
                                          : AdminViewDialogStyles
                                              .imageButtonStyle,
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.add),
                                            Text(
                                              landingPageData.imageURL == ''
                                                  ? 'Add Image'
                                                  : 'Change Image',
                                              style: AdminViewDialogStyles
                                                  .buttonTextStyle,
                                            )
                                          ]),
                                    ),
                                    AdminViewDialogStyles.interTitleField,
                                    AdminViewDialogStyles.interTitleField,
                                    if (noImage)
                                      Text(
                                        'Please add an image',
                                        style: AdminViewDialogStyles
                                            .errorTextStyle,
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
                                  if (landingPageData.imageURL == '' &&
                                      pickedImageBytes == null) {
                                    noImage = true;
                                    setState(() {});
                                  }
                                  if (formKey.currentState!.validate() &&
                                      !noImage) {
                                    formKey.currentState!.save();
                                    if (pickedImageBytes != null) {
                                      String? imageURL =
                                          await UploadImageAdminController()
                                              .uploadImageAndGetURL(
                                                  pickedImageBytes!,
                                                  'landing_page_image.jpg');
                                      if (imageURL != null) {
                                        landingPageData.imageURL = imageURL;
                                      }
                                    }
                                    bool? isSuccess = await _adminController
                                        .updateLandingPageData(landingPageData);
                                    if (!mounted) return;
                                    if (isSuccess != null && isSuccess) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(successMessage)),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(errorMessage)),
                                      );
                                    }
                                    Navigator.of(dialogContext).pop();
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
