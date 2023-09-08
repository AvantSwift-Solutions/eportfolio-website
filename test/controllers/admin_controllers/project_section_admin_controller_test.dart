import 'package:avantswift_portfolio/controllers/admin_controllers/project_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/Project.dart';
import 'package:avantswift_portfolio/reposervice/project_repo_services.dart';
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

    when(pp1.ppid).thenReturn('mockid1');
    when(pp1.name).thenReturn('mock name1');

    when(pp2.ppid).thenReturn('mockid2');
    when(pp2.name).thenReturn('mock name2');

  });

  group('Project section admin controller tests', () {
  test('getAllProjects returns a list of  projects', () async {
    when(mockRepoService.getAllProjects()).thenAnswer((_) async => [pp1, pp2]);

    final projects = await controller.getProjectList();

    // expect(Projects, isA<List<Project>>());
    expect(projects?.length, equals(2));
  });

  test('getAllProjects returns null on error', () async {
    when(mockRepoService.getAllProjects()).thenThrow(Exception('Test Exception'));

    final projects = await controller.getProjectList();

    // expect(Projects, isA<List<Project>>());
    expect(projects, null);
  });

  test('updateProjectData returns true on successful update', () async {
    when(mockRepoService.getAllProjects()).thenAnswer((_) async
      => [pp1, pp2]);
    when(pp1.update()).thenAnswer((_) async => true);

    final updateResult = await controller.updateProjectData(0,
      Project(
        ppid: 'mockId1',
        name: 'Updated Project',
      ),
    );

    expect(updateResult, true);
    verify(pp1.name = 'Updated Project');

    verify(pp1.update()); // Verify that the method was called
  });

  test('updateProjectData returns false when  project is empty', () async {
    when(mockRepoService.getAllProjects()).thenAnswer((_) async => null);

    final updateResult = await controller.updateProjectData(0,
      Project(
        ppid: 'mockId1',
        name: 'Updated Project',
      ),
    );

    expect(updateResult, false);

    verifyNever(pp1.update());
    verifyNever(pp2.update());
  });

  // test('deleteProject deletes an existing  project', () async {
  //   final mockProjects = [pp1,pp2];
  //   const indexToDelete = 1;

  //   when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockProjects);
  //   when(mockProjects[indexToDelete].delete()).thenAnswer((_) async {});

  //   final deletedResult = await controller.deleteProject(indexToDelete);

  //   expect(deletedResult, isTrue);
  //   verify(mockProjects[indexToDelete].delete());
  // });

  // test('deleteProject returns false on error', () async {
  //   final mockProjects = [pp1];
  //   const indexToDelete = 0;

  //   when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockProjects);
  //   when(mockProjects[indexToDelete].delete()).thenThrow(Exception('Test Exception'));

  //   final deleteResult = await controller.deleteProject(indexToDelete);

  //   expect(deleteResult, isFalse);
  // });
  });
}
