import 'package:avantswift_portfolio/controller/admin_controllers/personal_project_admin_controller.dart';
import 'package:avantswift_portfolio/models/PersonalProject.dart';
import 'package:avantswift_portfolio/reposervice/personal_project_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'personal_project_admin_controller_test.mocks.dart';

@GenerateMocks([PersonalProjectRepoService])
class MockPersonalProject extends Mock implements PersonalProject {

  void main() {
    late PersonalProjectAdminController controller;
    late MockPersonalProjectRepoService mockRepoService;

    setUp(() {
      mockRepoService = MockPersonalProjectRepoService();
      controller = PersonalProjectAdminController(mockRepoService);
    });

    test('getAllProjects returns a list of personal projects', () async {
      final mockPersonalProjects = [
        PersonalProject(ppid: '1', name: 'Project 1'),
        PersonalProject(ppid: '2', name: 'Project 2'),
      ];
      when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockPersonalProjects);

      final personalProjects = await controller.getPersonalProjectList();

      expect(personalProjects, isA<List<PersonalProject>>());
      expect(personalProjects.length, equals(2));
    });

    test('getAllProjects returns an empty list on error', () async {
      when(mockRepoService.getAllProjects()).thenThrow(Exception('Test Exception'));

      final personalProjects = await controller.getPersonalProjectList();

      expect(personalProjects, isA<List<PersonalProject>>());
      expect(personalProjects.isEmpty, isTrue);
    });

    test('updatePersonalProjectData updates an existing personal project', () async {
      final mockPersonalProjects = [
        PersonalProject(ppid: '1', name: 'Project 1'),
        PersonalProject(ppid: '2', name: 'Project 2'),
      ];
      final updatedProject = PersonalProject(ppid: '1', name: 'Updated Project');
      const indexToUpdate = 0;

      when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockPersonalProjects);
      when(mockPersonalProjects[indexToUpdate].update()).thenAnswer((_) async => true);

      final updatedResult = await controller.updatePersonalProjectData(indexToUpdate, updatedProject);

      expect(updatedResult, isTrue);
      expect(mockPersonalProjects[indexToUpdate].name, 'Updated Project');
      verify(mockPersonalProjects[indexToUpdate].update()).called(1);

    });

    test('updatePersonalProjectData returns false on error', () async {
      final mockPersonalProjects = [PersonalProject(ppid: '1', name: 'Project 1')];
      final updatedProject = PersonalProject(ppid: '1', name: 'Updated Project');
      const indexToUpdate = 0;

      when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockPersonalProjects);
      when(mockPersonalProjects[indexToUpdate].update()).thenThrow(Exception('Test Exception'));

      final updateResult = await controller.updatePersonalProjectData(indexToUpdate, updatedProject);

      expect(updateResult, isFalse);
    });

    test('deletePersonalProject deletes an existing personal project', () async {
      final mockPersonalProjects = [
        PersonalProject(ppid: '1', name: 'Project 1'),
        PersonalProject(ppid: '2', name: 'Project 2'),
      ];
      const indexToDelete = 1;

      when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockPersonalProjects);
      when(mockPersonalProjects[indexToDelete].delete()).thenAnswer((_) async {});

      final deletedResult = await controller.deletePersonalProject(indexToDelete);

      expect(deletedResult, isTrue);
      verify(mockPersonalProjects[indexToDelete].delete()).called(1);
    });

    test('deletePersonalProject returns false on error', () async {
      final mockPersonalProjects = [PersonalProject(ppid: '1', name: 'Project 1')];
      const indexToDelete = 0;

      when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockPersonalProjects);
      when(mockPersonalProjects[indexToDelete].delete()).thenThrow(Exception('Test Exception'));

      final deleteResult = await controller.deletePersonalProject(indexToDelete);

      expect(deleteResult, isFalse);
    });
  }
}