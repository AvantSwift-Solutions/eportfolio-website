import 'package:flutter/material.dart';
import '../controller/view_controllers/landing_page_controller.dart';

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
                              landingPageData!.landingPageTitle,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              landingPageData.landingPageDescription,
                              style: TextStyle(fontSize: descriptionFontSize),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Image.network(
                      landingPageData.imageURL,
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
