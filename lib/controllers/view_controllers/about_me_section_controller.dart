import 'dart:developer';

import '../../constants.dart';
import '../../dto/about_me_section_dto.dart';
import '../../models/User.dart';
import '../../reposervice/user_repo_services.dart';

class AboutMeSectionController {
  final UserRepoService userRepoService;

  AboutMeSectionController(this.userRepoService); // Constructor

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
          imageURL: Constants.replaceImageURL,
        );
      }
    } catch (e) {
      log('Error getting about me section data: $e');
      return AboutMeSectionDTO(
        aboutMe: 'Error',
        imageURL: Constants.replaceImageURL,
      );
    }
  }
}
