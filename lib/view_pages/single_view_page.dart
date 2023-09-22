import 'package:avantswift_portfolio/view_pages/skills_education_section.dart';
import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'about_me_section.dart';
import 'experience_section.dart';
import 'contact_section.dart';
import 'menu_section.dart';

class SinglePageView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _skillsEduKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _awardsCertsKey = GlobalKey();

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

  void _scrollToSection(GlobalKey sectionKey) {
    final context = sectionKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionKeys = {
      'experience': _experienceKey,
      'skills_edu': _skillsEduKey,
      'projects': _projectsKey,
      'awards_certs': _awardsCertsKey,
      'contact': _contactKey
    };

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            kToolbarHeight -
            kBottomNavigationBarHeight,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              LandingPage(
                scrollToBottom: _scrollToContact,
              ),
              MenuSection(
                scrollToSection: _scrollToSection,
                sectionKeys: sectionKeys, // Pass the map of section keys
              ),
              const AboutMeSection(),
              const SizedBox(height: 500), // Add some spacing
              const ExperienceSection(),
              const SizedBox(height: 500),
              SkillsAndEducation(
                key: _skillsEduKey,
              ),
              const SizedBox(height: 100),
              ContactSection(key: _contactKey),
            ],
          ),
        ),
      ),
    );
  }
}
