import 'package:avantswift_portfolio/models/TSkill.dart';
import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/tskill_section_admin_controller.dart';
import 'package:tuple/tuple.dart';
import 'mocks/tskill_section_admin_controller_test.mocks.dart';

@GenerateMocks([TSkillRepoService])
class MockTSkill extends Mock implements TSkill {}

void main() {
  late MockTSkill mockTSkill1;
  late MockTSkill mockTSkill2;

  late TSkillSectionAdminController controller;
  late MockTSkillRepoService mockRepoService;

  setUp(() {
    mockTSkill1 = MockTSkill();
    when(mockTSkill1.creationTimestamp).thenReturn(Timestamp.now());
    when(mockTSkill1.tsid).thenReturn('mockTsid1');
    when(mockTSkill1.index).thenReturn(0);
    when(mockTSkill1.name).thenReturn('Mock Tskill 1');
    when(mockTSkill1.imageURL).thenReturn('http://example.com/mock_image1.jpg');

    mockTSkill2 = MockTSkill();
    when(mockTSkill2.creationTimestamp).thenReturn(Timestamp.now());
    when(mockTSkill2.tsid).thenReturn('mockTsid2');
    when(mockTSkill2.index).thenReturn(1);
    when(mockTSkill2.name).thenReturn('Mock Tskill 2');
    when(mockTSkill2.imageURL).thenReturn('http://example.com/mock_image2.jpg');

    mockRepoService = MockTSkillRepoService();
    controller = TSkillSectionAdminController(mockRepoService);
  });

  group('TSkill section admin controller tests', () {
    test('getSectionData returns correct data when tskill is not null',
        () async {
      when(mockRepoService.getAllTSkill())
          .thenAnswer((_) async => [mockTSkill1, mockTSkill2]);
      final allTSkill = await controller.getSectionData();

      // Make assertions on the returned data
      expect(allTSkill!.length, 2);

      var tskill1 = allTSkill[0];
      var tskill2 = allTSkill[1];

      expect(tskill1.creationTimestamp, mockTSkill1.creationTimestamp);
      expect(tskill1.tsid, mockTSkill1.tsid);
      expect(tskill1.index, mockTSkill1.index);
      expect(tskill1.name, mockTSkill1.name);
      expect(tskill1.imageURL, mockTSkill1.imageURL);

      expect(tskill2.creationTimestamp, mockTSkill2.creationTimestamp);
      expect(tskill2.tsid, mockTSkill2.tsid);
      expect(tskill2.index, mockTSkill2.index);
      expect(tskill2.name, mockTSkill2.name);
      expect(tskill2.imageURL, mockTSkill2.imageURL);
    });

    test('getSectionData returns null data when tskill is null', () async {
      when(mockRepoService.getAllTSkill()).thenAnswer((_) async => null);
      final tskillSectionData = await controller.getSectionData();
      expect(tskillSectionData, null);
    });

    test('getSectionData returns null data on exception', () async {
      when(mockRepoService.getAllTSkill())
          .thenThrow(Exception('Test Exception'));
      final tskillSectionData = await controller.getSectionData();
      expect(tskillSectionData, null);
    });

    test('getSectionName returns correct name', () {
      final sectionName = controller.getSectionName();
      expect(sectionName, 'Technical Skills');
    });

    test('returns empty list when section data is null', () async {
      when(controller.getSectionData()).thenAnswer((_) => Future.value(null));
      final titles = await controller.getSectionTitles();
      expect(titles, isEmpty);
    });

    test('returns list of titles when section data is not null', () async {
      when(controller.getSectionData())
          .thenAnswer((_) => Future.value([mockTSkill1, mockTSkill2]));
      final titles = await controller.getSectionTitles();
      expect(titles, [
        Tuple2(mockTSkill1.index, mockTSkill1.name),
        Tuple2(mockTSkill2.index, mockTSkill2.name),
      ]);
    });

    test('updateSectionOrder should update the indicies', () async {
      final items = [
        const Tuple2<int, String>(0, 'item1'),
        const Tuple2<int, String>(1, 'item2')
      ];
      final exps = [mockTSkill1, mockTSkill2];
      when(controller.getSectionData()).thenAnswer((_) async => exps);
      when(mockTSkill1.update()).thenAnswer((_) async => true);
      when(mockTSkill2.update()).thenAnswer((_) async => true);

      await controller.updateSectionOrder(items);

      verifyInOrder([
        mockTSkill1.index = 0,
        mockTSkill1.update(),
        mockTSkill2.index = 1,
        mockTSkill2.update(),
      ]);
    });

    test('defaultOrderName should return correctly', () {
      expect(controller.defaultOrderName(), 'Alphabetically');
    });

    test('applyDefaultOrder should sort objects in default order', () async {
      final list = [mockTSkill1, mockTSkill2];
      when(controller.getSectionData()).thenAnswer((_) async => list);
      when(mockTSkill1.name).thenReturn('b');
      when(mockTSkill2.name).thenReturn('a');
      when(mockTSkill1.update()).thenAnswer((_) async => true);
      when(mockTSkill2.update()).thenAnswer((_) async => false);

      await controller.applyDefaultOrder();

      expect(list[0].name, 'a');
      expect(list[1].name, 'b');
    });

    test(
        'deleteData should delete object at given index and update the index of remaining objects',
        () async {
      final list = [mockTSkill1, mockTSkill2];
      when(mockTSkill1.index).thenReturn(0);
      when(mockTSkill2.index).thenReturn(1);
      when(mockTSkill1.update()).thenAnswer((_) async => true);
      when(mockTSkill1.delete()).thenAnswer((_) async => true);
      when(mockTSkill2.update()).thenAnswer((_) async => true);
      when(mockTSkill2.delete()).thenAnswer((_) async => true);

      final result = await controller.deleteData(list, 0);

      verifyInOrder([
        mockTSkill2.index = 0,
        mockTSkill2.update(),
        mockTSkill1.delete(),
      ]);
      expect(list[0].index, 0);
      expect(result, true);
    });

    test('deleteData should return false if deleting object fails', () async {
      final list = [mockTSkill1];
      when(mockTSkill1.delete()).thenThrow(Exception());

      final result = await controller.deleteData(list, 0);

      expect(result, false);
    });
  });
}
