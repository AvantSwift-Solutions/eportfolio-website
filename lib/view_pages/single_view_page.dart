import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'about_me_section.dart';
import 'experience_section.dart';
import 'contact_section.dart';

class SinglePageView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contactKey = GlobalKey();

  SinglePageView({super.key});

  void _scrollToContact() {
    final context = _contactKey.currentContext;
    if (context != null) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            kToolbarHeight -
            kBottomNavigationBarHeight, // Adjust height as needed
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              LandingPage(
                scrollToBottom: _scrollToContact, // Scroll to contact
              ),
              const SizedBox(height: 500), // Add some spacing
              const AboutMeSection(),
              const SizedBox(height: 500), // Add some spacing
              const ExperienceSection(),
              const SizedBox(height: 500), // Add some spacing
              ContactSection(
                  key: _contactKey), // Placeholder for contact section
            ],
          ),
        ),
      ),
    );
  }
}
