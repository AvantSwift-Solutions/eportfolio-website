import 'package:avantswift_portfolio/view_pages/about_me_section.dart';
import 'package:avantswift_portfolio/view_pages/project_section.dart';
import 'package:avantswift_portfolio/view_pages/award_cert_section.dart';
import 'package:avantswift_portfolio/view_pages/skills_education_section.dart';
import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'experience_section.dart';
import 'contact_section.dart';
import 'menu_section.dart';
import 'header_section.dart';
import 'footer_section.dart';

class SinglePageView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _skillsEduKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _awardsCertsKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _landingPageKey = GlobalKey();

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
      'contact': _contactKey,
      'menu': _menuKey,
      'landing_page': _landingPageKey,
    };

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          HeaderSection(
            scrollToSection: _scrollToSection, 
            sectionKeys: sectionKeys
          ), // Add the StickyHeader widget here
          SliverToBoxAdapter(
            child: SizedBox(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    LandingPage(
                      key: _landingPageKey,
                      scrollToBottom: _scrollToContact,
                    ),
                    const SizedBox(height: 100),
                    MenuSection(
                      key: _menuKey,
                      scrollToSection: _scrollToSection,
                      sectionKeys: sectionKeys,
                    ),
                    const AboutMeSection(),
                    const SizedBox(height: 100),
                    ExperienceSection(key: _experienceKey),
                    const SizedBox(height: 100),
                    SkillsAndEducation(key: _skillsEduKey),
                    const SizedBox(height: 100),
                    ProjectSection(key: _projectsKey),
                    const SizedBox(height: 100),
                    AwardCertSection(key: _awardsCertsKey),
                    const SizedBox(height: 100),
                    ContactSection(key: _contactKey),
                    const SizedBox(height: 100),
                    FooterSection(
                      scrollToSection: _scrollToSection,
                      sectionKeys: sectionKeys
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
