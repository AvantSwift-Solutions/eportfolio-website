import 'package:avantswift_portfolio/dto/contact_section_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../controllers/view_controllers/contact_section_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_view_button.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  ContactSectionState createState() => ContactSectionState();
}

class ContactSectionState extends State<ContactSection> {
  ContactSectionDTO contactSectionData = ContactSectionDTO(
      name: Constants.defaultName,
      contactEmail: Constants.defaultEmail,
      linkedinURL: Constants.defaultLinkedinURL);

  final ContactSectionController _contactSectionController =
      ContactSectionController(UserRepoService());
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    contactSectionData =
        await _contactSectionController.getContactSectionData();
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void clear() {
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }

  Map<String, String> getFields() {
    return {
      'from_name': _nameController.text,
      'from_email': _emailController.text,
      'subject': _subjectController.text,
      'message': _messageController.text,
    };
  }

  static const InputDecoration formDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
  );

  static const singleColumnThreshold = 1000;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    EdgeInsets sectionPadding = const EdgeInsets.symmetric(horizontal: 50);

    SizedBox interHeaderTitleSpacing = const SizedBox(height: 60);
    SizedBox formFieldSpacing = const SizedBox(height: 20);
    SizedBox interFormSendSpacing = const SizedBox(height: 40);
    SizedBox socialMediaSpacing = const SizedBox(height: 20);

    int maxMessageLines = 10;
    int maxMessageLength = 250;
    int characterLimit = 75;

    double sectionHeaderFontSize = 50;
    double titleFontSize = 40;
    double textSize = 25;

    double iconWidth = 90;
    double interIconTextWidth = 12;

    Widget sectionHeaderWidget = Text(
      'Let\'s Get in Touch',
      style: PublicViewTextStyles.generalHeading.copyWith(
        fontSize: sectionHeaderFontSize,
      ),
    );

    SizedBox interEmailConnectSpacing = const SizedBox(height: 60);

    if (screenWidth < singleColumnThreshold) {
      interFormSendSpacing = const SizedBox(height: 20);
      sectionPadding = const EdgeInsets.symmetric(horizontal: 20);
    }

    Widget emailFormWidget = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send a Message',
            style: PublicViewTextStyles.generalSubHeading.copyWith(
              fontSize: titleFontSize,
            ),
          ),
          const Divider(),
          formFieldSpacing,
          TextFormField(
            controller: _nameController,
            decoration: formDecoration.copyWith(hintText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              } else if (value.isNotEmpty && value.length > characterLimit) {
                return 'Name must be less than $characterLimit characters';
              }
              return null;
            },
          ),
          formFieldSpacing,
          TextFormField(
            controller: _emailController,
            decoration: formDecoration.copyWith(hintText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email';
              } else if (value.isNotEmpty && value.length > characterLimit) {
                return 'Email must be less than $characterLimit characters';
              }
              return null;
            },
          ),
          formFieldSpacing,
          TextFormField(
            controller: _subjectController,
            decoration: formDecoration.copyWith(hintText: 'Subject'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a subject';
              } else if (value.isNotEmpty && value.length > characterLimit) {
                return 'Subject must be less than $characterLimit characters';
              }
              return null;
            },
          ),
          formFieldSpacing,
          TextFormField(
            controller: _messageController,
            maxLines: maxMessageLines,
            maxLength: maxMessageLength,
            maxLengthEnforcement: MaxLengthEnforcement.none,
            decoration: formDecoration.copyWith(hintText: 'Message'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a message';
              } else if (value.isNotEmpty && value.length > maxMessageLength) {
                return 'Message must be less than $maxMessageLength characters';
              }
              return null;
            },
          ),
          interFormSendSpacing,
          CustomViewButton(
            text: 'Send',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final fields = getFields();
                clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sending email...'),
                  ),
                );
                final res = await _contactSectionController.sendEmail(
                    contactSectionData, fields);
                if (!mounted) return;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                if (res) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email sent successfully'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error sending email'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );

    Widget connectTitleWidget = Text(
      'Connect Further',
      style: PublicViewTextStyles.generalSubHeading.copyWith(
        fontSize: titleFontSize,
      ),
    );

    Widget linkedinHeadingWidget = Row(
      children: [
        SizedBox(width: iconWidth + interIconTextWidth),
        Text(
          'LinkedIn',
          style: PublicViewTextStyles.generalBodyText.copyWith(
            fontSize: textSize,
          ),
        ),
      ],
    );

    Widget linkedinDisplayWidget = Row(
      children: [
        SvgPicture.network(
          Constants.linkedinSVGURL,
          width: iconWidth,
        ),
        SizedBox(width: interIconTextWidth),
        GestureDetector(
          onTap: () {
            launchUrl(Uri.parse(
                contactSectionData.linkedinURL ?? 'https://www.linkedin.com/'));
          },
          child: Text(
            '@${contactSectionData.name}',
            style: PublicViewTextStyles.generalSubHeading.copyWith(
              fontSize: textSize,
            ),
          ),
        ),
      ],
    );

    if (screenWidth > singleColumnThreshold) {
      return Padding(
        padding: sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            sectionHeaderWidget,
            interHeaderTitleSpacing,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: emailFormWidget,
                ),
                // Dummy coloumn for formatting
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      connectTitleWidget,
                      const Divider(),
                      socialMediaSpacing,
                      linkedinHeadingWidget,
                      linkedinDisplayWidget,
                      const Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            sectionHeaderWidget,
            interHeaderTitleSpacing,
            emailFormWidget,
            interEmailConnectSpacing,
            connectTitleWidget,
            const Divider(),
            socialMediaSpacing,
            linkedinHeadingWidget,
            linkedinDisplayWidget,
            const Divider(),
          ],
        ),
      );
    }
  }
}
