import 'package:flutter/material.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';

class UITestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Test Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Heading Text',
              style: PublicViewTextStyles.generalHeading,
            ),
            const SizedBox(height: 20),
            Text(
              'Sub-heading Text',
              style: PublicViewTextStyles.generalSubHeading,
            ),
            const SizedBox(height: 20),
            Text(
              'Body Text',
              style: PublicViewTextStyles.generalBodyText,
            ),
            const SizedBox(height: 20),
            PublicViewTextStyles.styledLogo(),
            const SizedBox(height: 20),
            Text(
              'Nike, Melbourne',
              style: PublicViewTextStyles.professionalExperienceHeading,
            ),
            Text(
              'Sep 2022 - Present',
              style: PublicViewTextStyles.professionalExperienceSubHeading,
            ),
          ],
        ),
      ),
    );
  }
}
