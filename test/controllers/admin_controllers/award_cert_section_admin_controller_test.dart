import 'package:avantswift_portfolio/controllers/admin_controllers/award_cert_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'mocks/award_cert_section_admin_controller_test.mocks.dart';

@GenerateMocks([AwardCertRepoService])
class MockAwardCert extends Mock implements AwardCert {}

void main() {
  late AwardCert ac1;
  late AwardCert ac2;

  late AwardCertSectionAdminController controller;
  late MockAwardCertRepoService mockRepoService;

  setUp(() {
    mockRepoService = MockAwardCertRepoService();
    controller = AwardCertSectionAdminController(mockRepoService);

    ac1 = MockAwardCert();
    ac2 = MockAwardCert();

    when(ac1.acid).thenReturn('mockid1');
    when(ac1.name).thenReturn('mock name1');
    when(ac1.link).thenReturn('https://example.com/mock_certification1.pdf');
    when(ac1.source).thenReturn('mock source1');

    when(ac2.acid).thenReturn('mockid2');
    when(ac2.name).thenReturn('mock name2');
    when(ac2.link).thenReturn('https://example.com/mock_certification2.pdf');
    when(ac2.source).thenReturn('mock source2');
  });

  group('Award Cert section admin controller tests', () {
    test('getAwardCertList returns a list of awardcerts', () async {
      when(mockRepoService.getAllAwardCert())
          .thenAnswer((_) async => [ac1, ac2]);

      final awardCerts = await controller.getAwardCertSectionData();

      expect(awardCerts?.length, 2);

      var awardCert1 = awardCerts?[0];
      var awardCert2 = awardCerts?[1];

      expect(awardCert1?.acid, ac1.acid);
      expect(awardCert1?.name, ac1.name);

      expect(awardCert2?.link, ac2.link);
      expect(awardCert2?.source, ac2.source);
    });

    test('getAwardCertList returns null on error', () async {
      when(mockRepoService.getAllAwardCert())
          .thenThrow(Exception('Test Exception'));

      final awardCerts = await controller.getAwardCertSectionData();

      expect(awardCerts, null);
    });

    test('updateAwardCertData updates an existing awardcert and returns true',
        () async {
      when(mockRepoService.getAllAwardCert())
          .thenAnswer((_) async => [ac1, ac2]);
      when(ac1.update()).thenAnswer((_) async => true);

      const indexToUpdate = 0;
      final updatedAwardCert = AwardCert(
          acid: 'mockid1',
          name: 'Updated Certificate',
          link: 'https://example.com/mock_certification1_new.pdf',
          source: 'mock source1');
      final updatedResult =
          await controller.updateAwardCertData(indexToUpdate, updatedAwardCert);

      expect(updatedResult, isTrue);
      verify(ac1.name = 'Updated Certificate');
      verify(ac1.link = 'https://example.com/mock_certification1_new.pdf');

      verify(ac1.update());
    });

    test('updateAwardCertData returns false on awardcerts is null', () async {
      final updatedAwardCert = AwardCert(
          acid: 'mockid1',
          name: 'Updated Certificate',
          link: 'https://example.com/mock_certification1_new.pdf',
          source: 'mock source1');
      const indexToUpdate = 0;

      when(mockRepoService.getAllAwardCert()).thenAnswer((_) async => null);

      final updateResult =
          await controller.updateAwardCertData(indexToUpdate, updatedAwardCert);

      expect(updateResult, isFalse);

      verifyNever(ac1.update());
      verifyNever(ac2.update());
    });
  });
}
