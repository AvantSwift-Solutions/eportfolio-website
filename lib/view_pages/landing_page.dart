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

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  landingPageData!.landingPageTitle,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  landingPageData.landingPageDescription,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                // Image.network(
                //   landingPageData.imageURL,
                //   width: 200,
                //   height: 200,
                //   fit: BoxFit.cover,
                // ),
                SizedBox(height: 10),
                Text(
                  'Name: ${landingPageData.name}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
