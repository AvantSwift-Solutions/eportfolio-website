import 'package:avantswift_portfolio/controllers/view_controllers/award_cert_section_controller.dart';
import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/award_cert_section_controller_test.mocks.dart';

@GenerateMocks([AwardCertRepoService, AwardCert])
void main() {
  group('AwardCertsController Tests', () {
    late AwardCertSectionController controller;
    late MockAwardCertRepoService mockRepoService;
    late MockAwardCert mockAwardCert1;
    late MockAwardCert mockAwardCert2;

    setUp(() {
      mockAwardCert1 = MockAwardCert();
      when(mockAwardCert1.acid).thenReturn('mockId1');
      when(mockAwardCert1.name).thenReturn('Mock Name 1');
      when(mockAwardCert1.imageURL).thenReturn('http://example.com/image1.png');
      when(mockAwardCert1.link).thenReturn('http://example1.com');
      when(mockAwardCert1.source).thenReturn('Mock Source 1');

      mockAwardCert2 = MockAwardCert();
      when(mockAwardCert2.acid).thenReturn('mockId2');
      when(mockAwardCert2.name).thenReturn('Mock Name 2');
      when(mockAwardCert2.imageURL).thenReturn('http://example.com/image2.png');
      when(mockAwardCert2.link).thenReturn('http://example2.com');
      when(mockAwardCert2.source).thenReturn('Mock Source 2');

      mockRepoService = MockAwardCertRepoService();
      controller = AwardCertSectionController(mockRepoService);
    });

    test('getAllAwardCerts returns a list of awardcerts', () async {
      // ignore: non_constant_identifier_names
      final awardCerts = [
        AwardCert(
            creationTimestamp: Timestamp.now(),
            acid: 'mockId1',
            index: 0,
            name: 'Mock Name 1',
            imageURL: 'http://example.com/image1.png',
            link: 'http://example1.com',
            source: 'Mock Source 1',
            dateIssued: Timestamp.fromMicrosecondsSinceEpoch(0)),
        AwardCert(
            creationTimestamp: Timestamp.now(),
            acid: 'mockId2',
            index: 0,
            name: 'Mock Name 2',
            imageURL: 'http://example.com/image2.png',
            link: 'http://example2.com',
            source: 'Mock Source 2',
            dateIssued: Timestamp.fromMicrosecondsSinceEpoch(0)),
      ];

      when(mockRepoService.getAllAwardCert())
          .thenAnswer((_) async => awardCerts);

      final awardCertList = await controller.getAwardCertList();

      expect(awardCertList!.length, 2);

      var awardCert1 = awardCertList[0];
      var awardCert2 = awardCertList[1];

      expect(awardCert1.name, mockAwardCert1.name);
      expect(awardCert1.imageURL, mockAwardCert1.imageURL);
      expect(awardCert1.link, mockAwardCert1.link);
      expect(awardCert1.source, mockAwardCert1.source);

      expect(awardCert2.name, mockAwardCert2.name);
      expect(awardCert2.imageURL, mockAwardCert2.imageURL);
      expect(awardCert2.link, mockAwardCert2.link);
      expect(awardCert2.source, mockAwardCert2.source);

      verify(mockRepoService.getAllAwardCert());
    });

    test('getAllProjects returns null on error', () async {
      when(mockRepoService.getAllAwardCert())
          .thenThrow(Exception('Test Exception'));

      final awardCerts = await controller.getAwardCertList();
      expect(awardCerts, null);
    });
  });
}
