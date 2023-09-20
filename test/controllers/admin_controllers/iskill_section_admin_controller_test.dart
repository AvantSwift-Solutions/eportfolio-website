import 'package:avantswift_portfolio/models/ISkill.dart';
import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/iskill_section_admin_controller.dart';
import 'package:tuple/tuple.dart';
import 'mocks/iskill_section_admin_controller_test.mocks.dart';

@GenerateMocks([ISkillRepoService])
class MockISkill extends Mock implements ISkill {}

void main() {
  late MockISkill mockISkill1;
  late MockISkill mockISkill2;

  late ISkillSectionAdminController controller;
  late MockISkillRepoService mockRepoService;

  setUp(() {
    mockISkill1 = MockISkill();
    when(mockISkill1.creationTimestamp).thenReturn(Timestamp.now());
    when(mockISkill1.isid).thenReturn('mockIsid1');
    when(mockISkill1.index).thenReturn(0);
    when(mockISkill1.name).thenReturn('Mock ISkill 1');

    mockISkill2 = MockISkill();
    when(mockISkill2.creationTimestamp).thenReturn(Timestamp.now());
    when(mockISkill2.isid).thenReturn('mockIsid2');
    when(mockISkill2.index).thenReturn(1);
    when(mockISkill2.name).thenReturn('Mock ISkill 2');

    mockRepoService = MockISkillRepoService();
    controller = ISkillSectionAdminController(mockRepoService);
  });

  group('ISkill section admin controller tests', () {
    test('getSectionData returns correct data when iskill is not null',
        () async {
      when(mockRepoService.getAllISkill())
          .thenAnswer((_) async => [mockISkill1, mockISkill2]);
      final allISkill = await controller.getSectionData();

      // Make assertions on the returned data
      expect(allISkill!.length, 2);

      var iskill1 = allISkill[0];
      var iskill2 = allISkill[1];

      expect(iskill1.creationTimestamp, mockISkill1.creationTimestamp);
      expect(iskill1.isid, mockISkill1.isid);
      expect(iskill1.index, mockISkill1.index);
      expect(iskill1.name, mockISkill1.name);

      expect(iskill1.creationTimestamp, mockISkill1.creationTimestamp);
      expect(iskill2.isid, mockISkill2.isid);
      expect(iskill2.index, mockISkill2.index);
      expect(iskill2.name, mockISkill2.name);
    });

    test('getSectionData returns null data when iskill is null', () async {
      when(mockRepoService.getAllISkill()).thenAnswer((_) async => null);
      final iskillSectionData = await controller.getSectionData();
      expect(iskillSectionData, null);
    });

    test('getSectionData returns null data on exception', () async {
      when(mockRepoService.getAllISkill())
          .thenThrow(Exception('Test Exception'));
      final iskillSectionData = await controller.getSectionData();
      expect(iskillSectionData, null);
    });

    test('getSectionName returns correct name', () {
      final sectionName = controller.getSectionName();
      expect(sectionName, 'Interpersonal Skills');
    });

    test('returns empty list when section data is null', () async {
      when(controller.getSectionData()).thenAnswer((_) => Future.value(null));
      final titles = await controller.getSectionTitles();
      expect(titles, isEmpty);
    });

    test('returns list of titles when section data is not null', () async {
      when(controller.getSectionData())
          .thenAnswer((_) => Future.value([mockISkill1, mockISkill2]));
      final titles = await controller.getSectionTitles();
      expect(titles, [
        Tuple2(mockISkill1.index, mockISkill1.name),
        Tuple2(mockISkill2.index, mockISkill2.name),
      ]);
    });

    test('updateSectionOrder should update the indicies', () async {
      final items = [
        const Tuple2<int, String>(0, 'item1'),
        const Tuple2<int, String>(1, 'item2')
      ];
      final exps = [mockISkill1, mockISkill2];
      when(controller.getSectionData()).thenAnswer((_) async => exps);
      when(mockISkill1.update()).thenAnswer((_) async => true);
      when(mockISkill2.update()).thenAnswer((_) async => true);

      await controller.updateSectionOrder(items);

      verifyInOrder([
        mockISkill1.index = 0,
        mockISkill1.update(),
        mockISkill2.index = 1,
        mockISkill2.update(),
      ]);
    });

    test('defaultOrderName should return correctly', () {
      expect(controller.defaultOrderName(), 'Alphabetically');
    });

    test('applyDefaultOrder should sort objects in default order', () async {
      final list = [mockISkill1, mockISkill2];
      when(controller.getSectionData()).thenAnswer((_) async => list);
      when(mockISkill1.name).thenReturn('b');
      when(mockISkill2.name).thenReturn('a');
      when(mockISkill1.update()).thenAnswer((_) async => true);
      when(mockISkill2.update()).thenAnswer((_) async => false);

      await controller.applyDefaultOrder();

      expect(list[0].name, 'a');
      expect(list[1].name, 'b');
    });

    test(
        'deleteData should delete object at given index and update the index of remaining objects',
        () async {
      final list = [mockISkill1, mockISkill2];
      when(mockISkill1.index).thenReturn(0);
      when(mockISkill2.index).thenReturn(1);
      when(mockISkill1.update()).thenAnswer((_) async => true);
      when(mockISkill1.delete()).thenAnswer((_) async => true);
      when(mockISkill2.update()).thenAnswer((_) async => true);
      when(mockISkill2.delete()).thenAnswer((_) async => true);

      final result = await controller.deleteData(list, 0);

      verifyInOrder([
        mockISkill2.index = 0,
        mockISkill2.update(),
        mockISkill1.delete(),
      ]);
      expect(list[0].index, 0);
      expect(result, true);
    });

    test('deleteData should return false if deleting object fails', () async {
      final list = [mockISkill1];
      when(mockISkill1.delete()).thenThrow(Exception());

      final result = await controller.deleteData(list, 0);

      expect(result, false);
    });
  });
}
