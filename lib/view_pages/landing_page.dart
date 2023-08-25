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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }

          final landingPageData = snapshot.data;

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Constrained width text boxes
                    Container(
                      width: 500, // Adjust this value as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            landingPageData!.landingPageTitle,
                            style: const TextStyle(
                              fontSize: 56, // Increased font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20), // Increased spacing
                          Text(
                            landingPageData.landingPageDescription,
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20), // Adding some horizontal spacing
                    // Image on the right
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Image.network(
                          landingPageData.imageURL,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
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
