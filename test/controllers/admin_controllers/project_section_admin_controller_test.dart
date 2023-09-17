import 'package:avantswift_portfolio/controllers/admin_controllers/project_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/Project.dart';
import 'package:avantswift_portfolio/reposervice/project_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'mocks/project_section_admin_controller_test.mocks.dart';

@GenerateMocks([ProjectRepoService])
class MockProject extends Mock implements Project {}

void main() {
  late Project pp1;
  late Project pp2;

  late ProjectSectionAdminController controller;
  late MockProjectRepoService mockRepoService;

  setUp(() {
    mockRepoService = MockProjectRepoService();
    controller = ProjectSectionAdminController(mockRepoService);

    pp1 = MockProject();
    pp2 = MockProject();

    when(pp1.creationTimestamp).thenReturn(Timestamp.now());
    when(pp1.ppid).thenReturn('mockid1');
    when(pp1.index).thenReturn(0);
    when(pp1.name).thenReturn('mock name1');
    when(pp1.description).thenReturn('mock desc1');
    when(pp1.link).thenReturn('https://example.com/mock_project1.pdf');

    when(pp2.creationTimestamp).thenReturn(Timestamp.now());
    when(pp2.ppid).thenReturn('mockid2');
    when(pp2.index).thenReturn(1);
    when(pp2.name).thenReturn('mock name2');
    when(pp2.description).thenReturn('mock desc2');
    when(pp2.link).thenReturn('https://example.com/mock_project2.pdf');

  });

  group('Project section admin controller tests', () {
    test('getAllProjects returns a list of  projects', () async {
      when(mockRepoService.getAllProjects())
          .thenAnswer((_) async => [pp1, pp2]);

      final projects = await controller.getSectionData();
      expect(projects?.length, 2);
      var project1 = projects?[0];
      var project2 = projects?[1];

      expect(project1?.creationTimestamp, pp1.creationTimestamp);
      expect(project1?.ppid, pp1.ppid);
      expect(project1?.index, pp1.index);
      expect(project1?.name, pp1.name);
      expect(project1?.description, pp1.description);
      expect(project1?.link, pp1.link);

      expect(project2?.creationTimestamp, pp2.creationTimestamp);
      expect(project2?.ppid, pp2.ppid);
      expect(project2?.index, pp2.index);
      expect(project2?.name, pp2.name);
      expect(project2?.description, pp2.description);
      expect(project2?.link, pp2.link);

    });

    test('getAllProjects returns null on error', () async {
      when(mockRepoService.getAllProjects())
          .thenThrow(Exception('Test Exception'));

      final projects = await controller.getSectionData();
      expect(projects, null);
    });

    test('getSectionName returns correct name', () {
      final sectionName = controller.getSectionName();
      expect(sectionName, 'Project');
    });

  });

}
