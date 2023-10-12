import 'package:avantswift_portfolio/models/Secret.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/reposervice/secret_repo_services.dart';

class LoginController {
  void onLoginSuccess(User user) {
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


