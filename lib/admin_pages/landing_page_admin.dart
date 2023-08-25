// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../controller/admin_controllers/landing_page_admin_controller.dart';

class LandingPageAdmin extends StatelessWidget {
  final LandingPageAdminController _adminController =
      LandingPageAdminController();

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
              child: const Text('Edit User Info'),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) async {
    final landingPageData = await _adminController.getLandingPageData();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit your landing page information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: TextEditingController(text: landingPageData.name),
                  onChanged: (value) => landingPageData.name = value,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: TextEditingController(
                      text: landingPageData.landingPageTitle),
                  onChanged: (value) =>
                      landingPageData.landingPageTitle = value,
                  decoration:
                      const InputDecoration(labelText: 'Landing Page Title'),
                ),
                TextField(
                  controller: TextEditingController(
                      text: landingPageData.landingPageDescription),
                  onChanged: (value) =>
                      landingPageData.landingPageDescription = value,
                  decoration: const InputDecoration(
                      labelText: 'Landing Page Description'),
                ),
                TextField(
                  controller:
                      TextEditingController(text: landingPageData.imageURL),
                  onChanged: (value) => landingPageData.imageURL = value,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                bool isSuccess = await _adminController
                    .updateLandingPageData(landingPageData);
                if (isSuccess) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User info updated')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Failed to update user info')));
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
  }
}
