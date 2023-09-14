import 'package:flutter/material.dart';
import 'contact_section.dart';
import 'landing_page.dart';
import 'menu_section.dart';
import 'about_me_section.dart';

class SinglePageView extends StatelessWidget {
  
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _awardsKey = GlobalKey();
  final GlobalKey _landingkey = GlobalKey();

  SinglePageView({super.key});

  // void _scrollToContact() {
  //   final context = _contactKey.currentContext;
  //   if (context != null) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }


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
      'skills': _skillsKey,
      'projects': _projectsKey,
      'awards': _awardsKey,
      'contact': _contactKey,
      'landing': _landingkey
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
                key: _landingkey,
                scrollToBottom: _scrollToSection//_scrollToContact,
              ),
              MenuSection(
                scrollToSection: _scrollToSection,
                sectionKeys: sectionKeys, // Pass the map of section keys
              ),
              const AboutMeSection(),
              const SizedBox(height: 500),
              ContactSection(key: _contactKey),
              // Add your other sections here with their respective GlobalKey
              // Example: MySkillsSection(key: _skillsKey),
              // Example: MyProjectsSection(key: _projectsKey),
              // Example: MyAwardsSection(key: _awardsKey),
            ],
          ),
        ),
      ),
    );
  }
}
