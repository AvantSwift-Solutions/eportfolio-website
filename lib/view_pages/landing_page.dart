import 'package:flutter/material.dart';
import '../controller/view_controllers/landing_page_controller.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class LandingPage extends StatelessWidget {
  final LandingPageController _landingPageController = LandingPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
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
          double descriptionFontSize = screenWidth * 0.01;
          double textImagePadding =
              screenWidth * 0.15; // Adjust the factor as needed

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: textImagePadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              landingPageData?.landingPageTitle ??
                                  'Default Title',
                              style:
                                  PublicViewTextStyles.generalHeading.copyWith(
                                fontSize: titleFontSize,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              landingPageData?.landingPageDescription ??
                                  'Default Description',
                              style:
                                  PublicViewTextStyles.generalBodyText.copyWith(
                                fontSize: descriptionFontSize,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Image.network(
                      landingPageData?.imageURL ??
                          'https://example.com/default_image.jpg',
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.7,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
