import 'package:avantswift_portfolio/controllers/admin_controllers/award_cert_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';
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

  group('Award Cert section admin controller tests:', () {
    test('getSectionData returns a list of awardcerts', () async {
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

    test('getSectionData returns null on error', () async {
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

    test('getSectionTitles returns empty list when section data is null', () async {
      when(controller.getSectionData()).thenAnswer((_) => Future.value(null));
      final titles = await controller.getSectionTitles();
      expect(titles, isEmpty);
    });

    test('getSectionTitles returns list of titles when section data is not null', () async {
      when(controller.getSectionData())
          .thenAnswer((_) => Future.value([ac1, ac2]));
      final titles = await controller.getSectionTitles();
      expect(titles, [
        Tuple2(ac1.index, '${ac1.name} from ${ac1.source}'),
        Tuple2(ac2.index, '${ac2.name} from ${ac2.source}'),
      ]);
    });

    test('getSectionTitles returns empty list when exception is thrown', () async {
      when(controller.getSectionData()).thenThrow(Exception());
      final titles = await controller.getSectionTitles();
      expect(titles, isEmpty);
    });

    test('updateSectionOrder should update the indicies', () async {
      final items = [
        const Tuple2<int, String>(0, 'item1'),
        const Tuple2<int, String>(1, 'item2')
      ];
      final exps = [ac1, ac2];
      when(controller.getSectionData()).thenAnswer((_) async => exps);
      when(ac1.update()).thenAnswer((_) async => true);
      when(ac2.update()).thenAnswer((_) async => true);

      await controller.updateSectionOrder(items);

      verifyInOrder([
        ac1.index = 0,
        ac1.update(),
        ac2.index = 1,
        ac2.update(),
      ]);
    });

    test('defaultOrderName should return correctly', () {
      expect(controller.defaultOrderName(), 'by Date Issued');
    });

    test('applyDefaultOrder should sort objects in default order', () async {
      MockAwardCert ac3 = MockAwardCert();
      final list = [ac3, ac1, ac2];
      when(controller.getSectionData()).thenAnswer((_) async => list);
      when(ac1.dateIssued).thenReturn(Timestamp.fromMicrosecondsSinceEpoch(1));
      when(ac2.dateIssued).thenReturn(Timestamp.fromMicrosecondsSinceEpoch(2));
      when(ac3.dateIssued).thenReturn(null);
      when(ac1.update()).thenAnswer((_) async => true);
      when(ac2.update()).thenAnswer((_) async => false);

      await controller.applyDefaultOrder();

      expect(list[0].dateIssued, null);
      expect(list[1].dateIssued, Timestamp.fromMicrosecondsSinceEpoch(2));
      expect(list[2].dateIssued, Timestamp.fromMicrosecondsSinceEpoch(1));
    });

    test(
        'deleteData should delete object at given index and update the index of remaining objects',
        () async {
      final list = [ac1, ac2];
      when(ac1.index).thenReturn(0);
      when(ac2.index).thenReturn(1);
      when(ac1.update()).thenAnswer((_) async => true);
      when(ac1.delete()).thenAnswer((_) async => true);
      when(ac2.update()).thenAnswer((_) async => true);
      when(ac2.delete()).thenAnswer((_) async => true);

      final result = await controller.deleteData(list, 0);

      verifyInOrder([
        ac2.index = 0,
        ac2.update(),
        ac1.delete(),
      ]);
      expect(list[0].index, 0);
      expect(result, true);
    });

    test('deleteData should return false if deleting object fails', () async {
      final list = [ac1];
      when(ac1.delete()).thenThrow(Exception());

      final result = await controller.deleteData(list, 0);

      expect(result, false);
    });
  });
}
