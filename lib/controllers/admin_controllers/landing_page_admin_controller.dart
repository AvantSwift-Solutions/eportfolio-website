import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../dto/landing_page_dto.dart';
import '../../models/User.dart';
import '../../reposervice/user_repo_services.dart'; // Import the User class

class LandingPageAdminController {
  final UserRepoService userRepoService;

  LandingPageAdminController(this.userRepoService); // Constructor

  Future<LandingPageDTO>? getLandingPageData() async {
    try {
      User? user = await userRepoService.getFirstUser();
      if (user != null) {
        return LandingPageDTO(
          name: user.name,
          nickname: user.nickname,
          landingPageDescription: user.landingPageDescription,
          imageURL: user.imageURL,
        );
      } else {
        return LandingPageDTO(
          name: 'Unknown',
          nickname: 'Welcome',
          landingPageDescription: 'No description available',
          imageURL: 'https://example.com/default_image.jpg',
        );
      }
    } catch (e) {
      log('Error getting landing page data: $e');
      return LandingPageDTO(
        name: 'Error',
        nickname: 'Error',
        landingPageDescription: 'Error',
        imageURL: 'https://example.com/error.jpg',
      );
    }
  }

  Future<bool>? updateLandingPageData(LandingPageDTO landingPageData) async {
    try {
      User? user = await userRepoService.getFirstUser();

      if (user != null) {
        user.name = landingPageData.name;
        user.nickname = landingPageData.nickname;
        user.landingPageDescription = landingPageData.landingPageDescription;

        /* ImageURL requires additional steps of taking to storage and
         getting the URL */
        user.imageURL = landingPageData.imageURL;

        bool updateSuccess = await user.update() ?? false;
        return updateSuccess; // Return true if update is successful
      } else {
        return false;
      }
    } catch (e) {
      log('Error updating landing page data: $e');
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
      log('Error uploading image: $e');
      return null;
    }
  }
}
