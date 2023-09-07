import 'package:avantswift_portfolio/controller/admin_controllers/award_cert_admin_controller.dart';
import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'award_cert_admin_controller_test.mocks.dart';

@GenerateMocks([AwardCertRepoService])
class MockAwardCertAdminController extends Mock implements AwardCertAdminController {
  void main() {
    late AwardCertAdminController controller;
    late MockAwardCertRepoService mockRepoService;

    setUp(() {
      mockRepoService = MockAwardCertRepoService();
      controller = AwardCertAdminController(mockRepoService);
    });

    test('getAwardCertList returns a list of awardcerts', () async {
      final mockAwardCerts = [
        AwardCert(acid: '', name: '', link: '', source: ''),
        AwardCert(acid: '', name: '', link: '', source: ''),
      ];
      when(mockRepoService.getAllAwardCert()).thenAnswer((_) async => mockAwardCerts);

      final awardCerts = await controller.getAwardCertList();

      expect(awardCerts, isA<List<AwardCert>>());
      expect(awardCerts.length, equals(2));
    });

    test('getAwardCertList returns an empty list on error', () async {
      when(mockRepoService.getAllAwardCert()).thenThrow(Exception('Test Exception'));

      final awardCerts = await controller.getAwardCertList();

      expect(awardCerts, isA<List<AwardCert>>());
      expect(awardCerts.isEmpty, isTrue);
    });

    test('updateAwardCertData updates an existing awardcert', () async {
      final mockAwardCerts = [
        AwardCert(acid: '', name: '', link: '', source: ''),
        AwardCert(acid: '', name: '', link: '', source: ''),
      ];
      final updatedAwardCert = AwardCert(acid: '', name: '', link: '', source: '');
      const indexToUpdate = 0;

      when(mockRepoService.getAllAwardCert()).thenAnswer((_) async => mockAwardCerts);
      when(mockAwardCerts[indexToUpdate].update()).thenAnswer((_) async => true);

      final updatedResult = await controller.updateAwardCertData(indexToUpdate, updatedAwardCert);

      expect(updatedResult, isTrue);
      expect(mockAwardCerts[indexToUpdate].name, 'Updated Project');
      verify(mockAwardCerts[indexToUpdate].update()).called(1);

    });

    test('updateAwardCertData returns false on error', () async {
      final mockAwardCerts = [AwardCert(acid: '', name: '', link: '', source: '')];
      final updatedAwardCert = AwardCert(acid: '', name: '', link: '', source: '');
      const indexToUpdate = 0;

      when(mockRepoService.getAllAwardCert()).thenAnswer((_) async => mockAwardCerts);
      when(mockAwardCerts[indexToUpdate].update()).thenThrow(Exception('Test Exception'));

      final updateResult = await controller.updateAwardCertData(indexToUpdate, updatedAwardCert);

      expect(updateResult, isFalse);
    });

    test('deleteAwardCert deletes an existing awardcert', () async {
      final mockAwardCerts = [
        AwardCert(acid: '', name: '', link: '', source: ''),
        AwardCert(acid: '', name: '', link: '', source: ''),
      ];
      const indexToDelete = 1;

      when(mockRepoService.getAllAwardCert()).thenAnswer((_) async => mockAwardCerts);
      when(mockAwardCerts[indexToDelete].delete()).thenAnswer((_) async {});

      final deletedResult = await controller.deleteAwardCert(indexToDelete);

      expect(deletedResult, isTrue);
      verify(mockAwardCerts[indexToDelete].delete()).called(1);
    });

    test('deletePersonalProject returns false on error', () async {
      final mockAwardCerts = [AwardCert(acid: '', name: '', link: '', source: '')];
      const indexToDelete = 0;

      when(mockRepoService.getAllAwardCert()).thenAnswer((_) async => mockAwardCerts);
      when(mockAwardCerts[indexToDelete].delete()).thenThrow(Exception('Test Exception'));

      final deleteResult = await controller.deleteAwardCert(indexToDelete);

      expect(deleteResult, isFalse);
    });
  }
}