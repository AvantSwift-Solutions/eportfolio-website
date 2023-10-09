// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Secret {
  final String? secretId;
  final String? serviceId;
  final String? templateId;
  final String? userId;
  final String? accessToken;

  Secret({
    required this.secretId,
    required this.serviceId,
    required this.templateId,
    required this.userId,
    required this.accessToken,
  });

  factory Secret.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final secretId = data['secretId'] as String;
    final serviceId = data['serviceId'];
    final templateId = data['templateId'];
    final userId = data['userId'];
    final accessToken = data['accessToken'];

    return Secret(
      secretId: secretId,
      serviceId: serviceId,
      templateId: templateId,
      userId: userId,
      accessToken: accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'secretId': secretId,
      'serviceId': serviceId,
      'templateId': templateId,
      'userId': userId,
      'accessToken': accessToken,
    };
  }
}
