import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../dto/about_me_section_dto.dart';
import '../../models/User.dart';
import '../../reposervice/user_repo_services.dart'; // Import the User class

class AboutMeSectionAdminController {
  final UserRepoService userRepoService;

  AboutMeSectionAdminController(this.userRepoService); // Constructor

  Future<AboutMeSectionDTO>? getAboutMeSectionData() async {
    try {
      User? user = await userRepoService.getFirstUser();
      if (user != null) {
        return AboutMeSectionDTO(
          aboutMe: user.aboutMe,
          imageURL: user.imageURL,
        );
      } else {
        return AboutMeSectionDTO(
          aboutMe: 'No description available',
          imageURL: 'https://example.com/default_image.jpg',
        );
      }
    } catch (e) {
      return AboutMeSectionDTO(
        aboutMe: 'Error',
        imageURL: 'https://example.com/error.jpg',
      );
    }
  }

  Future<bool>? updateAboutMeSectionData(
      AboutMeSectionDTO aboutMeSectionData) async {
    try {
      User? user = await userRepoService.getFirstUser();

      if (user != null) {
        user.aboutMe = aboutMeSectionData.aboutMe;

        /* ImageURL requires additional steps of taking to storage and
         getting the URL */
        user.imageURL = aboutMeSectionData.imageURL;

        bool updateSuccess = await user.update() ?? false;
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
