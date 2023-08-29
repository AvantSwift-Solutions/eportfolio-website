import 'package:cloud_firestore/cloud_firestore.dart';

import '../../dto/landing_page_dto.dart';
import '../../models/User.dart';

class LandingPageController {
  Future<User?> getFirstUser() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('User').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        return User.fromDocumentSnapshot(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<LandingPageDTO>? getLandingPageData() async {
    try {
      User? user = await getFirstUser();
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
