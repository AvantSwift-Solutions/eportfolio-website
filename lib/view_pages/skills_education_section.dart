import 'package:avantswift_portfolio/view_pages/technical_skills_section.dart';
import 'package:flutter/material.dart';

import '../ui/custom_texts/public_view_text_styles.dart';
import 'education_section.dart';
import 'interpersonal_skills_section.dart';

// Import your TechnicalSkillsWidget and InterpersonalSkillsWidget here

class SkillsAndEducation extends StatelessWidget {
  const SkillsAndEducation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth <= 800;
    double titleFontSize =
        isMobileView ? screenWidth * 0.07 : screenWidth * 0.035;
    double gap = isMobileView ? screenWidth * 0.1 : screenWidth * 0.07;
    double generalPadding =
        isMobileView ? screenWidth * 0.05 : screenWidth * 0.02;
    double leftPadding = isMobileView ? screenWidth * 0.05 : screenWidth * 0.02;
    double spacing = isMobileView ? screenWidth * 0.05 : screenWidth * 0.02;
    double offset = screenWidth * 0.05;

    if (!isMobileView) {
      return Padding(
        padding:
            EdgeInsets.all(generalPadding), // Add padding around the widget
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Skills & Education',
                style: PublicViewTextStyles.generalHeading.copyWith(
                    fontWeight: FontWeight.bold, fontSize: titleFontSize),
              ),

              SizedBox(height: spacing),

              // Content (Two Columns)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Column - TechnicalSkillsWidget
                  Container(
                    padding: EdgeInsets.only(left: leftPadding),
                    child: const TechnicalSkillsWidget(),
                  ),

                  SizedBox(width: gap),
                  // Right Column
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const EducationSection(),
                          ),
                          SizedBox(height: spacing), // Adjust vertical spacing
                          // InterpersonalSkillsWidget
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.05,
                                ),
                                const Expanded(
                                  child: InterpersonalSkillsWidget(),
                                ),
                              ],
                            ),
                          ),
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
    } else {
      return Padding(
        padding:
            EdgeInsets.all(generalPadding), // Add padding around the widget
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: Text(
                  'Skills & Education',
                  style: PublicViewTextStyles.generalHeading.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                ),
              ),

              // Technical Skills
              Padding(
                padding: EdgeInsets.only(left: leftPadding, right: gap),
                child: const TechnicalSkillsWidget(),
              ),

              SizedBox(height: spacing),

              // Interpersonal Skills
              Padding(
                padding:
                    EdgeInsets.only(left: leftPadding + offset, right: gap),
                child: const InterpersonalSkillsWidget(),
              ),

              SizedBox(height: spacing),

              // Education Section
              Padding(
                padding: EdgeInsets.only(left: leftPadding, right: gap),
                child: const EducationSection(),
              ),
            ],
          ),
        ),
      );
    }
  }
}
