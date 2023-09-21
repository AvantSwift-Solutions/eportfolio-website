import 'dart:developer';

import '../../constants.dart';
import '../../dto/landing_page_dto.dart';
import '../../models/User.dart';
import '../../reposervice/user_repo_services.dart';

class LandingPageController {
  final UserRepoService userRepoService;

  LandingPageController(this.userRepoService); // Constructor

  Future<LandingPageDTO>? getLandingPageData() async {
    try {
      User? user = await userRepoService.getFirstUser();
      String? firstName = user?.name?.split(' ').first; // Only shows firstname
      if (user != null) {
        return LandingPageDTO(
          name: firstName ?? Constants.defaultName,
          nickname: user.nickname,
          landingPageDescription: user.landingPageDescription,
          imageURL: user.imageURL,
        );
      } else {
        return LandingPageDTO(
          name: Constants.defaultName,
          nickname: Constants.defaultNickname,
          landingPageDescription: 'No description available',
          imageURL: Constants.replaceImageURL,
        );
      }
    } catch (e) {
      log('Error getting landing page data: $e');
      return LandingPageDTO(
        name: 'Error',
        nickname: 'Error',
        landingPageDescription: 'Error',
        imageURL: Constants.replaceImageURL,
      );
    }
  }
}
