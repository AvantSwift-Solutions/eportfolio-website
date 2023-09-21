import 'package:avantswift_portfolio/controllers/view_controllers/interpersonal_skills_section_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/ISkill.dart'; // Update with the correct import path
import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart'; // Update with the correct import path

class MockISkillRepoService extends Mock implements ISkillRepoService {}

void main() {
  group('InterpersonalSkillsController Tests', () {
    late InterpersonalSkillsController controller;
    late MockISkillRepoService mockRepoService;

    setUp(() {
      mockRepoService = MockISkillRepoService();
      controller = InterpersonalSkillsController(mockRepoService);
    });

    test('getIPersonalSkills returns a list of skill names', () async {
      final iSkills = [
        ISkill(name: 'Skill1', isid: '1', creationTimestamp: null, index: 1),
        ISkill(name: 'Skill2', isid: '2', creationTimestamp: null, index: 2),
      ];
      when(mockRepoService.getAllISkill()).thenAnswer((_) async => iSkills);
      final skillNames = await controller.getIPersonalSkills();
      expect(skillNames, ['Skill1', 'Skill2']);
      verify(mockRepoService.getAllISkill());
    });

    test('getIPersonalSkills handles errors', () async {
      when(mockRepoService.getAllISkill()).thenThrow(Exception('Test Error'));
      final skillNames = await controller.getIPersonalSkills();
      expect(skillNames, isNull);
    });
  });
}
