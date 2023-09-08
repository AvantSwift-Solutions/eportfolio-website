import '../../dto/contact_section_dto.dart';
import '../../models/User.dart';
import '../../reposervice/user_repo_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
            linkedinURL: user.linkedinURL);
      } else {
        return ContactSectionDTO(
            name: 'Unknown',
            contactEmail: 'No email avaliable',
            linkedinURL: 'No LinkedIn avaliable');
      }
    } catch (e) {
      return ContactSectionDTO(
          name: 'Error', contactEmail: 'Error', linkedinURL: 'Error');
    }
  }

  Future<bool> sendEmail(
      ContactSectionDTO? contactSectionData, Map<String, String> fields) async {
    final toName = contactSectionData?.name;
    final toEmail = contactSectionData?.contactEmail;

    const serviceId = 'service_wp59pl6';
    const templateId = 'template_6atjqpb';
    const userId = 'ydMCRddLc0NvkjQM5';
    const accessToken = '1Uf6JLM9il0xwhzJZfTxj';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'accessToken': accessToken,
        'template_params': {
          'to_name': toName,
          'to_email': toEmail,
          'from_name': fields['from_name'],
          'from_email': fields['from_email'],
          'subject': fields['subject'],
          'message': fields['message'],
        },
      }),
    );

    return response.body == 'OK';
  }
}
