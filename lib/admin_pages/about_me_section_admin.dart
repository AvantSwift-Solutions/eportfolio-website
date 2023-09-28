import 'package:avantswift_portfolio/controllers/admin_controllers/upload_image_admin_controller.dart';
import 'package:avantswift_portfolio/dto/about_me_section_dto.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/about_me_section_admin_controller.dart';

class AboutMeSectionAdmin extends StatefulWidget {
  const AboutMeSectionAdmin({super.key});

  @override
  State<AboutMeSectionAdmin> createState() => _AboutMeSectionAdminState();
}

class _AboutMeSectionAdminState extends State<AboutMeSectionAdmin> {
  final maxBioLength = 400;
  late AboutMeSectionAdminController _adminController;
  late AboutMeSectionDTO aboutMeData;

  @override
  void initState() {
    super.initState();
    _adminController = AboutMeSectionAdminController(UserRepoService());
    _loadItems();
  }

  Future<void> _loadItems() async {
    aboutMeData = await _adminController.getAboutMeSectionData()
        // Should never be null as it is handled in the controller
        ??
        AboutMeSectionDTO(aboutMe: '', imageURL: '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showEditDialog(context);
              },
              child: const Text('Edit About Me Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Uint8List? pickedImageBytes;
    // Flag to check if user tried to sumbit without picking a required image
    bool noImage = false;

    String title, successMessage, errorMessage;
    title = 'Edit About Me info';
    successMessage = 'About Me info updated successfully';
    errorMessage = 'Error updating About Me info';

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
                                    const Text('About Me Bio*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    TextFormField(
                                      maxLines:
                                          AdminViewDialogStyles.textBoxLines,
                                      maxLength: maxBioLength,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.none,
                                      style:
                                          AdminViewDialogStyles.inputTextStyle,
                                      initialValue: aboutMeData.aboutMe,
                                      decoration:
                                          AdminViewDialogStyles.inputDecoration,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a biography';
                                        } else if (value.isNotEmpty &&
                                            value.length > maxBioLength) {
                                          return 'Please reduce the length of the biography';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        aboutMeData.aboutMe = value;
                                      },
                                    ),
                                    AdminViewDialogStyles.spacer,
                                    const Text('About Me Image*',
                                        textAlign: TextAlign.left),
                                    AdminViewDialogStyles.interTitleField,
                                    if (pickedImageBytes != null)
                                      Image.memory(pickedImageBytes!,
                                          width:
                                              AdminViewDialogStyles.imageWidth),
                                    if (aboutMeData.imageURL != '' &&
                                        pickedImageBytes == null)
                                      Image.network(aboutMeData.imageURL!,
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
                                              aboutMeData.imageURL == ''
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
                                  if (aboutMeData.imageURL == '' &&
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
                                                  'about_me_image.jpg');
                                      if (imageURL != null) {
                                        aboutMeData.imageURL = imageURL;
                                      }
                                    }
                                    bool? isSuccess = await _adminController
                                        .updateAboutMeSectionData(aboutMeData);
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
