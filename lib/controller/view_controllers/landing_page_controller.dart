import '../../dto/landing_page_dto.dart';
import '../../models/User.dart';

class LandingPageController {
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
}
