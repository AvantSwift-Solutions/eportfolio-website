import 'package:flutter/material.dart';
import '../controllers/view_controllers/about_me_section_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class AboutMeSection extends StatefulWidget {
  const AboutMeSection({super.key});

  @override
  AboutMeSectionState createState() => AboutMeSectionState();
}

class AboutMeSectionState extends State<AboutMeSection> {
  final AboutMeSectionController _aboutMeSectionController =
      AboutMeSectionController(UserRepoService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _aboutMeSectionController.getAboutMeSectionData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final aboutMeSectionData = snapshot.data;
        final screenWidth = MediaQuery.of(context).size.width;

        double titleFontSize = screenWidth * 0.05;
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
                        'A Bit About Myself...',
                        style: PublicViewTextStyles.generalHeading.copyWith(
                          fontSize: titleFontSize * 0.8,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        aboutMeSectionData?.aboutMe ?? 'Default Description',
                        style: PublicViewTextStyles.generalBodyText.copyWith(
                          fontSize: descriptionFontSize * 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 100.0), // Adjust padding as needed
                    child: Image.network(
                      aboutMeSectionData?.imageURL ??
                          'https://example.com/default_image.jpg',
                      width: 200,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
