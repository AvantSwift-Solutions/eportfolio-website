import 'package:flutter/material.dart';
import '../controllers/view_controllers/landing_page_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_scroll_button.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class LandingPage extends StatefulWidget {
  final Function scrollToBottom;

  const LandingPage({super.key, required this.scrollToBottom});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final LandingPageController _landingPageController =
      LandingPageController(UserRepoService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _landingPageController.getLandingPageData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final landingPageData = snapshot.data;
        final screenWidth = MediaQuery.of(context).size.width;

        double titleFontSize = screenWidth * 0.05;
        double descriptionFontSize = screenWidth * 0.015;

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
                        landingPageData?.landingPageTitle ?? 'Default Title',
                        style: PublicViewTextStyles.generalHeading.copyWith(
                          fontSize: titleFontSize,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        landingPageData?.landingPageDescription ??
                            'Default Description',
                        style: PublicViewTextStyles.generalBodyText.copyWith(
                          fontSize: descriptionFontSize,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomScrollButton(
                        text: 'Contact Me',
                        onPressed: () {
                          widget.scrollToBottom();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 100.0), // Adjust padding as needed
                    child: Image.network(
                      landingPageData?.imageURL ??
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
