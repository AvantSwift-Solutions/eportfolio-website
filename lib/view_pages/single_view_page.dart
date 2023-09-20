import 'package:avantswift_portfolio/view_pages/about_me_section.dart';
import 'package:avantswift_portfolio/view_pages/skills_education_section.dart';
import 'package:flutter/material.dart';
import 'contact_section.dart';
import 'education_section.dart';
import 'landing_page.dart';

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
              const SizedBox(height: 100), // Add some spacing
              const AboutMeSection(),
              const SizedBox(height: 100), // Add some spacing
              // InterpersonalSkillsWidget(),
              // const SizedBox(height: 100),
              const SkillsAndEducation(),
              // const TechnicalSkillsWidget(), // Add some spacing
              const SizedBox(height: 500), // Add some spacing
              const EducationSection(),
              const SizedBox(height: 100),

              ContactSection(
                  key: _contactKey), // Placeholder for contact section
            ],
          ),
        ),
      ),
    );
  }
}
