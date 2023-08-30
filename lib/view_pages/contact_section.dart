import 'dart:convert';

import 'package:flutter/material.dart';
import '../controller/view_controllers/contact_section_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import 'package:http/http.dart' as http;

class ContactSection extends StatefulWidget {
  ContactSection({Key? key}) : super(key: key);

  @override
  _ContactSectionState createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
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

  Future sendEmail() async {

    const to_name = 'Vincent';
    const to_email = 'vinnyluu.02@gmail.com';
    
    const serviceId = 'service_wp59pl6';
    const templateId = 'template_6atjqpb';
    const userId = 'ydMCRddLc0NvkjQM5';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_name': to_name,
          'to_email': to_email,
          'from_name': _nameController.text,
          'from_email': _emailController.text,
          'subject': _subjectController.text,
          'message': _messageController.text,
        },
      }),
    );
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

        double descriptionFontSize = screenWidth * 0.01;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              // Use Row for side-by-side layout
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1, // Adjust flex as needed
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _subjectController,
                            decoration: InputDecoration(
                              labelText: 'Subject',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a subject';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              labelText: 'Message',
                            ),
                            maxLines: null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a message';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await sendEmail();
                                clear();
                              }
                            },
                            child: const Text('Send'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2, // Adjust flex as needed
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contactSectionData?.contactEmail ?? 'Default Email',
                          style: PublicViewTextStyles.generalBodyText.copyWith(
                            fontSize: descriptionFontSize,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          contactSectionData?.linkedinURL ?? 'Default LinkedIn',
                          style: PublicViewTextStyles.generalBodyText.copyWith(
                            fontSize: descriptionFontSize,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}