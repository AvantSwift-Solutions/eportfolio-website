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
    return Padding(
      padding:
          const EdgeInsets.all(50.0), // Add padding of 50 around the widget
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Skills & Education',
              style: PublicViewTextStyles.generalHeading
                  .copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Content (Two Columns)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Column - TechnicalSkillsWidget
                Container(
                  padding: const EdgeInsets.only(left: 120),
                  child: const TechnicalSkillsWidget(),
                ),

                const SizedBox(width: 200),
                // Right Column
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          // decoration: BoxDecoration(
                          //   border: Border.all(
                          //     color: Colors.black, // Border color
                          //     width: 2.0, // Border width
                          //   ),
                          // ),
                          child: const EducationSection(),
                        ),
                        const SizedBox(height: 20), // Adjust vertical spacing
                        // InterpersonalSkillsWidget
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: InterpersonalSkillsWidget(),
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
  }
}
