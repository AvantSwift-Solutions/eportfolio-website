import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../dto/landing_page_dto.dart';
import '../../models/User.dart'; // Import the User class

class LandingPageAdminController {
  Future<LandingPageDTO> getLandingPageData() async {
    try {
      User? user = await User.getFirstUser();

      if (user != null) {
        return LandingPageDTO(
          name: user.name,
          landingPageTitle: user.landingPageTitle,
          landingPageDescription: user.landingPageDescription,
          imageURL: user.imageURL,
        );
      } else {
        return LandingPageDTO(
          name: 'Unknown',
          landingPageTitle: 'Welcome',
          landingPageDescription: 'No description available',
          imageURL: 'https://example.com/default_image.jpg',
        );
      }
    } catch (e) {
      return LandingPageDTO(
        name: 'Error',
        landingPageTitle: 'Error',
        landingPageDescription: 'Error',
        imageURL: 'https://example.com/default_image.jpg',
      );
    }
  }

  Future<bool> updateLandingPageData(LandingPageDTO landingPageData) async {
    try {
      User? user = await User.getFirstUser();

      if (user != null) {
        user.name = landingPageData.name;
        user.landingPageTitle = landingPageData.landingPageTitle;
        user.landingPageDescription = landingPageData.landingPageDescription;

        /* ImageURL requires additional steps of taking to storage and
         getting the URL */
        user.imageURL = landingPageData.imageURL;

        bool updateSuccess = await user.update();
        return updateSuccess; // Return true if update is successful
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadImageAndGetURL(
      Uint8List imageBytes, String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final imageURL = await snapshot.ref.getDownloadURL();
      return imageURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
