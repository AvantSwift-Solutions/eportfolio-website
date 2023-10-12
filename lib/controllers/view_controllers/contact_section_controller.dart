import 'dart:developer';

import 'package:avantswift_portfolio/controllers/analytic_controller.dart';
import 'package:avantswift_portfolio/models/Secret.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:avantswift_portfolio/reposervice/secret_repo_services.dart';

import '../../constants.dart';
import '../../dto/contact_section_dto.dart';
import '../../models/User.dart';
import '../../reposervice/user_repo_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactSectionController {
  final UserRepoService userRepoService;

  ContactSectionController(this.userRepoService); // Constructor

  Future<ContactSectionDTO> getContactSectionData() async {
    try {
      User? user = await userRepoService.getFirstUser();
      if (user != null) {
        return ContactSectionDTO(
            name: user.name,
            contactEmail: user.contactEmail,
            linkedinURL: user.linkedinURL);
      } else {
        return ContactSectionDTO(
            name: Constants.defaultName,
            contactEmail: Constants.defaultEmail,
            linkedinURL: Constants.defaultLinkedinURL);
      }
    } catch (e) {
      log('Error getting contact section data: $e');
      return ContactSectionDTO(
          name: 'Error', contactEmail: 'Error', linkedinURL: 'Error');
    }
  }

  Future<bool> sendEmail(
      ContactSectionDTO? contactSectionData, Map<String, String> fields) async {
    SecretRepoService repoService = SecretRepoService();

    Secret s = await repoService.getSecret() ??
        Secret(
          secretId: 'a',
          serviceId: 'a',
          formTemplateId: 'a',
          loginTemplateId: 'a',
          userId: 'a',
          accessToken: 'a',
        );
    final toName = contactSectionData?.name;
    final toEmail = contactSectionData?.contactEmail;

    String serviceId = s.serviceId ?? '';
    String formTemplateId = s.formTemplateId ?? '';
    String userId = s.userId ?? '';
    String accessToken = s.accessToken ?? '';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': formTemplateId,
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

    if (response.body != 'OK') {
      log('Error sending email: ${response.body}');
    }
    AnalyticController.incrementMessages(AnalyticRepoService());
    return response.body == 'OK';
  }
}
