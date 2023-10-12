import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avantswift_portfolio/models/Secret.dart';
import 'package:mockito/mockito.dart';

// ignore: subtype_of_sealed_class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  DocumentSnapshotMock({required this.d});
  final Map<String, dynamic> d;
  @override
  Map<String, dynamic> data() => d;
}

void main() {
  group('Secret Model tests', () {
    test('fromDocumentSnapshot should return an Secret object', () {
      final data = {
        'secretId': 'secretId123',
        'serviceId': 'serviceId123',
        'formTemplateId': 'formTemplateId123',
        'loginTemplateId': 'loginTemplateId123',
        'userId': 'userId123',
        'accessToken': 'accessToken123',
      };
      final snapshot = DocumentSnapshotMock(d: data);

      final result = Secret.fromDocumentSnapshot(snapshot);

      expect(result.secretId, data['secretId']);
      expect(result.serviceId, data['serviceId']);
      expect(result.formTemplateId, data['formTemplateId']);
      expect(result.loginTemplateId, data['loginTemplateId']);
      expect(result.userId, data['userId']);
      expect(result.accessToken, data['accessToken']);
    });

    test('Secret.toMap should convert secret to a map', () {
      final secret = Secret(
        secretId: 'secretId123',
        serviceId: 'serviceId123',
        formTemplateId: 'formTemplateId123',
        loginTemplateId: 'loginTemplateId123',
        userId: 'userId123',
        accessToken: 'accessToken123',
      );
      final secretMap = secret.toMap();

      expect(secretMap['secretId'], secret.secretId);
      expect(secretMap['serviceId'], secret.serviceId);
      expect(secretMap['formTemplateId'], secret.formTemplateId);
      expect(secretMap['loginTemplateId'], secret.loginTemplateId);
      expect(secretMap['userId'], secret.userId);
      expect(secretMap['accessToken'], secret.accessToken);
    });
  });
}
