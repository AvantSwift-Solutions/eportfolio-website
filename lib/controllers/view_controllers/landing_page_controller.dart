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
      log('Error getting landing page data: $e');
      return LandingPageDTO(
        name: 'Error',
        landingPageTitle: 'Error',
        landingPageDescription: 'Error',
        imageURL: 'https://example.com/error.jpg',
      );
    }
  }
}
