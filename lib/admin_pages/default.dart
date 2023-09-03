import 'package:avantswift_portfolio/admin_pages/education_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/landing_page_admin.dart';
import 'package:avantswift_portfolio/admin_pages/contact_section_admin.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:flutter/material.dart';


class DefaultPage extends StatelessWidget {
  final User user;

  DefaultPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to your website',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              const Text(
                'You are logged in as an admin',
                style: TextStyle(fontSize: 16),
              ),
              LandingPageAdmin(), // Placing the LandingPageAdmin widget here
              EducationSectionAdmin(),
              ContactSectionAdmin(),
            ],
          ),
        ),
      ),
    );
  }
}
