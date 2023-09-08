import 'dart:developer';

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
          name: firstName ?? 'Unknown',
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
}
