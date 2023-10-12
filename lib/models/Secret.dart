// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Secret {
  final String? secretId;
  final String? serviceId;
  final String? formTemplateId;
  final String? loginTemplateId;
  final String? userId;
  final String? accessToken;

  Secret({
    required this.secretId,
    required this.serviceId,
    required this.formTemplateId,
    required this.loginTemplateId,
    required this.userId,
    required this.accessToken,
  });

  factory Secret.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final secretId = data['secretId'] as String;
    final serviceId = data['serviceId'];
    final formTemplateId = data['formTemplateId'];
    final loginTemplateId = data['loginTemplateId'];
    final userId = data['userId'];
    final accessToken = data['accessToken'];

    return Secret(
      secretId: secretId,
      serviceId: serviceId,
      formTemplateId: formTemplateId,
      loginTemplateId: loginTemplateId,
      userId: userId,
      accessToken: accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'secretId': secretId,
      'serviceId': serviceId,
      'formTemplateId': formTemplateId,
      'loginTemplateId': loginTemplateId,
      'userId': userId,
      'accessToken': accessToken,
    };
  }
}
