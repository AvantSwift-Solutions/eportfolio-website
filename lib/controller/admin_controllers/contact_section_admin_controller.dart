import '../../dto/contact_section_dto.dart';
import '../../models/User.dart';
import '../../reposervice/user_repo_services.dart'; // Import the User class

class ContactSectionAdminController {
  final UserRepoService userRepoService;

  ContactSectionAdminController(this.userRepoService); // Constructor

  Future<ContactSectionDTO>? getContactSectionData() async {
    try {
      User? user = await userRepoService.getFirstUser();
      if (user != null) {
        return ContactSectionDTO(
          contactEmail: user.contactEmail,
          linkedinURL: user.linkedinURL
        );
      } else {
        return ContactSectionDTO (
          contactEmail: 'No email avaliable',
          linkedinURL: 'No LinkedIn avaliable'
        );
      }
    } catch (e) {
      return ContactSectionDTO(
        contactEmail: 'Error',
        linkedinURL: 'Error'
      );
    }
  }

  Future<bool>? updateContactSectionData(ContactSectionDTO contactSectionData) async {
    try {
      User? user = await userRepoService.getFirstUser();

      if (user != null) {
        user.contactEmail = contactSectionData.contactEmail;
        user.linkedinURL = contactSectionData.linkedinURL;

        bool updateSuccess = await user.update() ?? false;
        return updateSuccess; // Return true if update is successful
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}
