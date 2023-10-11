import 'dart:developer';
import '../../models/AboutAss.dart';
import '../../reposervice/about_ass_repo_services.dart'; // Import the User class

class AboutAssSectionAdminController {
  final AboutAssRepoService aboutAssRepoService;

  AboutAssSectionAdminController(this.aboutAssRepoService); // Constructor

  Future<List<AboutAss>?>? getAboutAssSectionData() async {
    try {
      List<AboutAss>? allAboutAss = await aboutAssRepoService.getAllAboutAss();
      return allAboutAss;
    } catch (e) {
      log('Error getting About Ass list: $e');
      return null;
    }
  }
}
