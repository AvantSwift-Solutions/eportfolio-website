import 'package:flutter/material.dart';
import '../controller/view_controllers/contact_section_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class ContactSection extends StatelessWidget {
  ContactSection({Key? key}) : super(key: key);

  final ContactSectionController _contactSectionController =
      ContactSectionController(UserRepoService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _contactSectionController.getContactSectionData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final contactSectionData = snapshot.data;
        final screenWidth = MediaQuery.of(context).size.width;

        double descriptionFontSize = screenWidth * 0.01;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              // Use Row for side-by-side layout
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2, // Adjust flex as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contactSectionData?.contactEmail ?? 'Default Email',
                        style: PublicViewTextStyles.generalBodyText.copyWith(
                          fontSize: descriptionFontSize,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contactSectionData?.linkedinURL ?? 'Default LinkedIn',
                        style: PublicViewTextStyles.generalBodyText.copyWith(
                          fontSize: descriptionFontSize,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}