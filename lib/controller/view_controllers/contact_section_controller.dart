
import '../../dto/contact_section_dto.dart';
import '../../models/User.dart';
import '../../reposervice/user_repo_services.dart';

class ContactSectionController {
  final UserRepoService userRepoService;

  ContactSectionController(this.userRepoService); // Constructor

  Future<ContactSectionDTO>? getContactSectionData() async {
    try {
      User? user = await userRepoService.getFirstUser();
      if (user != null) {
        return ContactSectionDTO(
          name: user.name,
          contactEmail: user.contactEmail,
          linkedinURL: user.linkedinURL
        );
      } else {
        return ContactSectionDTO(
          name: 'No name avaliable',
          contactEmail: 'No email avaliable',
          linkedinURL: 'No LinkedIn avaliable'
        );
      }
    } catch (e) {
      return ContactSectionDTO(
        name: 'Error',
        contactEmail: 'Error',
        linkedinURL: 'Error'
      );
    }
  }
}
