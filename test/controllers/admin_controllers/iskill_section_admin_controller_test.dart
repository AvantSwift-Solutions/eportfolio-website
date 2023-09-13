import 'package:avantswift_portfolio/models/ISkill.dart';
import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart';
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
    when(mockISkill1.isid).thenReturn('mockIsid1');
    when(mockISkill1.index).thenReturn(0);
    when(mockISkill1.name).thenReturn('Mock ISkill 1');

    mockISkill2 = MockISkill();
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

      expect(iskill1.isid, mockISkill1.isid);
      expect(iskill1.index, mockISkill1.index);
      expect(iskill1.name, mockISkill1.name);

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
      expect(sectionName, 'Interpersonal Skill');
    });

    test('returns empty list when section data is null', () async {
      when(controller.getSectionData()).thenAnswer((_) => Future.value(null));
      final titles = await controller.getSectionTitles();
      expect(titles, isEmpty);
    });

    test('returns list of titles when section data is not null', () async {
      when(controller.getSectionData()).thenAnswer((_) => Future.value([
            ISkill(index: 1, name: 'Skill 1', isid: ''),
            ISkill(index: 2, name: 'Skill 2', isid: ''),
            ISkill(index: 3, name: 'Skill 3', isid: ''),
          ]));
      final titles = await controller.getSectionTitles();
      expect(titles, [
        const Tuple2(1, 'Skill 1'),
        const Tuple2(2, 'Skill 2'),
        const Tuple2(3, 'Skill 3'),
      ]);
    });
  });
}
