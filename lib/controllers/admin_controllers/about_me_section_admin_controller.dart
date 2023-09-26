import 'dart:developer';
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
          imageURL: user.aboutMeURL,
        );
      } else {
        return AboutMeSectionDTO(
          aboutMe: 'No description available',
          imageURL: 'https://example.com/default_image.jpg',
        );
      }
    } catch (e) {
      log('Error getting about me section data: $e');
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
        user.aboutMeURL = aboutMeSectionData.imageURL;

        bool updateSuccess = await user.update() ?? false;
        return updateSuccess; // Return true if update is successful
      } else {
        return false;
      }
    } catch (e) {
      log('Error updating about me section data: $e');
      return false;
    }
  }

}
