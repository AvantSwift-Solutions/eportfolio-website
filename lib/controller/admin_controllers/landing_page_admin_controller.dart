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
        user.imageURL = landingPageData.imageURL;

        await user.update();
        return true; // Return true if update is successful
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
