import 'package:avantswift_portfolio/controllers/admin_controllers/award_cert_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    when(ac1.creationTimestamp).thenReturn(Timestamp.now());
    when(ac1.acid).thenReturn('mockid1');
    when(ac1.index).thenReturn(0);
    when(ac1.name).thenReturn('mock name1');
    when(ac1.link).thenReturn('https://example.com/mock_certification1.pdf');
    when(ac1.source).thenReturn('mock source1');
    when(ac1.dateIssued).thenReturn(Timestamp.now());

    when(ac2.creationTimestamp).thenReturn(Timestamp.now());
    when(ac2.acid).thenReturn('mockid2');
    when(ac2.index).thenReturn(1);
    when(ac2.name).thenReturn('mock name2');
    when(ac2.link).thenReturn('https://example.com/mock_certification2.pdf');
    when(ac2.source).thenReturn('mock source2');
    when(ac2.dateIssued).thenReturn(Timestamp.now());
  });

  group('Award Cert section admin controller tests', () {
    test('getAwardCertList returns a list of awardcerts', () async {
      when(mockRepoService.getAllAwardCert())
          .thenAnswer((_) async => [ac1, ac2]);

      final awardCerts = await controller.getSectionData();

      expect(awardCerts?.length, 2);

      var awardCert1 = awardCerts?[0];
      var awardCert2 = awardCerts?[1];

      expect(awardCert1?.creationTimestamp, ac1.creationTimestamp);
      expect(awardCert1?.acid, ac1.acid);
      expect(awardCert1?.index, ac1.index);
      expect(awardCert1?.name, ac1.name);
      expect(awardCert1?.link, ac1.link);
      expect(awardCert1?.source, ac1.source);
      expect(awardCert1?.dateIssued, ac1.dateIssued);

      expect(awardCert2?.creationTimestamp, ac2.creationTimestamp);
      expect(awardCert2?.acid, ac2.acid);
      expect(awardCert2?.index, ac2.index);
      expect(awardCert2?.name, ac2.name);
      expect(awardCert2?.link, ac2.link);
      expect(awardCert2?.source, ac2.source);
      expect(awardCert2?.dateIssued, ac2.dateIssued);
    });

    test('getAwardCertList returns null on error', () async {
      when(mockRepoService.getAllAwardCert())
          .thenThrow(Exception('Test Exception'));

      final awardCerts = await controller.getSectionData();

      expect(awardCerts, null);
    });

    test('getSectionData returns null data on exception', () async {
      when(mockRepoService.getAllAwardCert())
          .thenThrow(Exception('Test Exception'));
      final awardCerts = await controller.getSectionData();
      expect(awardCerts, null);
    });

    test('getSectionName returns correct name', () {
      expect(controller.getSectionName(), 'Awards & Certifications');
    });
  });
}
