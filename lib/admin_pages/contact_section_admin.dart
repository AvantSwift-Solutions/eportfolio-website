// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:flutter/material.dart';
import '../controllers/admin_controllers/contact_section_admin_controller.dart';

class ContactSectionAdmin extends StatelessWidget {
  final ContactSectionAdminController _adminController =
      ContactSectionAdminController(UserRepoService());

  ContactSectionAdmin({super.key});

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
              child: const Text('Edit Contact Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) async {
    final contactSectionData = await _adminController.getContactSectionData();

    TextEditingController contactEmailController =
        TextEditingController(text: contactSectionData!.contactEmail);
    TextEditingController linkedinURLController =
        TextEditingController(text: contactSectionData.linkedinURL);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit your contact information'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: contactEmailController,
                      onChanged: (value) =>
                          contactSectionData.contactEmail = value,
                      decoration:
                          const InputDecoration(labelText: 'Contact Email'),
                    ),
                    TextField(
                      controller: linkedinURLController,
                      onChanged: (value) =>
                          contactSectionData.linkedinURL = value,
                      decoration:
                          const InputDecoration(labelText: 'LinkedIn URL'),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    bool isSuccess = await _adminController
                            .updateContactSectionData(contactSectionData) ??
                        false;
                    if (isSuccess) {
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Contact info updated')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Failed to update contact info')));
                    }
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
