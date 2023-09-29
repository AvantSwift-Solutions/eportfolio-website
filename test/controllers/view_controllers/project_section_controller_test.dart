import 'package:avantswift_portfolio/controllers/view_controllers/project_section_controller.dart';
import 'package:avantswift_portfolio/models/Project.dart';
import 'package:avantswift_portfolio/reposervice/project_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/project_section_controller_test.mocks.dart';

@GenerateMocks([ProjectRepoService, Project])
void main() {
  group('ProjectController Tests', () {
    late ProjectSectionController controller;
    late MockProjectRepoService mockRepoService;
    late MockProject mockProject1;
    late MockProject mockProject2;

    setUp(() {
      mockProject1 = MockProject();
      when(mockProject1.ppid).thenReturn('mockId1');
      when(mockProject1.name).thenReturn('Mock Name 1');
      when(mockProject1.description).thenReturn('Mock Description 1');
      when(mockProject1.link).thenReturn('http://example1.com');

      mockProject2 = MockProject();
      when(mockProject2.ppid).thenReturn('mockId2');
      when(mockProject2.name).thenReturn('Mock Name 2');
      when(mockProject2.description).thenReturn('Mock Description 2');
      when(mockProject2.link).thenReturn('http://example2.com');

      mockRepoService = MockProjectRepoService();
      controller = ProjectSectionController(mockRepoService);
    });

    test('getSectionDescription should return empty string if data is null',
        () async {
      when(mockRepoService.getDocumentById('Description'))
          .thenAnswer((_) async => null);

      final result = await controller.getSectionDescription();

      expect(result, '');
      verify(mockRepoService.getDocumentById('Description'));
    });

    test('getSectionDescription should return text if data is not null',
        () async {
      final data = {'text': 'Lorem ipsum'};
      when(mockRepoService.getDocumentById('Description'))
          .thenAnswer((_) async => data);

      final result = await controller.getSectionDescription();

      expect(result, 'Lorem ipsum');
      verify(mockRepoService.getDocumentById('Description'));
    });

    test('getAllProjects returns a list of projects', () async {
      // ignore: non_constant_identifier_names
      final projects = [
        Project(
          creationTimestamp: Timestamp.now(),
          index: 0,
          ppid: 'mockId1',
          name: 'Mock Name 1',
          description: 'Mock Description 1',
          link: 'http://example1.com',
        ),
        Project(
          creationTimestamp: Timestamp.now(),
          index: 1,
          ppid: 'mockId2',
          name: 'Mock Name 2',
          description: 'Mock Description 2',
          link: 'http://example2.com',
        ),
      ];

      when(mockRepoService.getAllProjects()).thenAnswer((_) async => projects);

      final projectList = await controller.getProjectList();

      expect(projectList!.length, 2);

      var project1 = projectList[0];
      var project2 = projectList[1];

      expect(project1.name, mockProject1.name);
      expect(project1.description, mockProject1.description);
      expect(project1.link, mockProject1.link);

      expect(project2.name, mockProject2.name);
      expect(project2.description, mockProject2.description);
      expect(project2.link, mockProject2.link);

      verify(mockRepoService.getAllProjects());
    });

    test('getAllProjects returns null on error', () async {
      when(mockRepoService.getAllProjects())
          .thenThrow(Exception('Test Exception'));

      final projects = await controller.getProjectList();
      expect(projects, null);
    });
  });
}
