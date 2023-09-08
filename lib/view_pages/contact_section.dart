// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../controllers/view_controllers/contact_section_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_scroll_button.dart';
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
  final ContactSectionController _contactSectionController =
      ContactSectionController(UserRepoService());
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _contactSectionController.getContactSectionData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final contactSectionData = snapshot.data;
        final screenWidth = MediaQuery.of(context).size.width;

        double titleFontSize = screenWidth * 0.03;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text(
                  'Let\'s Get in Touch',
                  style: PublicViewTextStyles.generalHeading.copyWith(
                    fontSize: titleFontSize*1.2,
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Form(
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
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Name',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Email',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!EmailValidator.validate(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _subjectController,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Subject',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a subject';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _messageController,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8.0),),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Message',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a message';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 20),
                              CustomScrollButton(
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
                                    final res = await _contactSectionController
                                      .sendEmail(contactSectionData, fields);
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
                        ),
                      ),
                    ),
                    // Dummy coloumn for formatting
                    const Expanded(flex: 1, child: Padding(padding: EdgeInsets.all(0))),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Connect Further',
                              style: PublicViewTextStyles.generalSubHeading.copyWith(
                                fontSize: titleFontSize,
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const SizedBox(width: 96),
                                Text(
                                  'Email',
                                  style: PublicViewTextStyles.generalBodyText.copyWith(
                                    fontSize: titleFontSize / 2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'mail.svg',
                                  width: 84,
                                  height: 84,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  contactSectionData?.contactEmail ?? 'No email avaliable',
                                  style: PublicViewTextStyles.generalSubHeading.copyWith(
                                    fontSize: titleFontSize / 2,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const SizedBox(width: 96),
                                Text(
                                  'LinkedIn',
                                  style: PublicViewTextStyles.generalBodyText.copyWith(
                                    fontSize: titleFontSize / 2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'linkedin.svg',
                                  width: 84,
                                  height: 84,
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse(contactSectionData?.linkedinURL ?? 'https://www.linkedin.com/'));
                                  },
                                  child: Text(
                                    '@${contactSectionData?.name}',
                                    style: PublicViewTextStyles.generalSubHeading.copyWith(
                                      fontSize: titleFontSize / 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}