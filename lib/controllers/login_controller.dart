import 'dart:convert';
import 'dart:developer';

import 'package:avantswift_portfolio/models/Secret.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/reposervice/secret_repo_services.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'view_controllers/contact_section_controller.dart';

class LoginController {
  Future<void> onLoginSuccess(User user, String toEmail) async {
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
    var contactSectionData = await ContactSectionController(UserRepoService())
        .getContactSectionData();
    final toName = contactSectionData.name;

    String serviceId = s.serviceId ?? '';
    String loginTemplateId = s.loginTemplateId ?? '';
    String userId = s.userId ?? '';
    String accessToken = s.accessToken ?? '';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final address = await IpAddress().getIpAddress();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': loginTemplateId,
        'user_id': userId,
        'accessToken': accessToken,
        'template_params': {
          'to_name': toName,
          'to_email': toEmail,
          'ip_address': address,
          'time': DateTime.now().toString(),
        },
      }),
    );

    if (response.body != 'OK') {
      log('Error sending email: ${response.body}');
    }
  }
}
