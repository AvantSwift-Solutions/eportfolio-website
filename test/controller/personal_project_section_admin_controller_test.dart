import 'package:avantswift_portfolio/controller/admin_controllers/personal_project_section_admin_controller.dart';
import 'package:avantswift_portfolio/models/PersonalProject.dart';
import 'package:avantswift_portfolio/reposervice/personal_project_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'personal_project_section_admin_controller_test.mocks.dart';

@GenerateMocks([PersonalProjectRepoService])
class MockPersonalProject extends Mock implements PersonalProject {}

  void main() {
    late PersonalProject pp1;
    late PersonalProject pp2;

    late PersonalProjectSectionAdminController controller;
    late MockPersonalProjectRepoService mockRepoService;

    setUp(() {
      mockRepoService = MockPersonalProjectRepoService();
      controller = PersonalProjectAdminController(mockRepoService);

      pp1 = MockPersonalProject();
      pp2 = MockPersonalProject();

      when(pp1.ppid).thenReturn('mockid1');
      when(pp1.name).thenReturn('mock name1');

      when(pp2.ppid).thenReturn('mockid2');
      when(pp2.name).thenReturn('mock name2');

    });

    test('getAllProjects returns a list of personal projects', () async {
      when(mockRepoService.getAllProjects()).thenAnswer((_) async => [pp1, pp2]);

      final personalProjects = await controller.getPersonalProjectList();

      // expect(personalProjects, isA<List<PersonalProject>>());
      expect(personalProjects?.length, equals(2));
    });

    test('getAllProjects returns null on error', () async {
      when(mockRepoService.getAllProjects()).thenThrow(Exception('Test Exception'));

      final personalProjects = await controller.getPersonalProjectList();

      // expect(personalProjects, isA<List<PersonalProject>>());
      expect(personalProjects, null);
    });

  test('updatePersonalProjectData returns true on successful update', () async {
    when(mockRepoService.getAllProjects()).thenAnswer((_) async
      => [pp1, pp2]);
    when(pp1.update()).thenAnswer((_) async => true);

    final updateResult = await controller.updatePersonalProjectData(0,
      PersonalProject(
        ppid: 'mockId1',
        name: 'Updated Project',
      ),
    );

    expect(updateResult, true);
    verify(pp1.name = 'Updated Project');

    verify(pp1.update()); // Verify that the method was called
  });

  test('updatePersonalProjectData returns false when personal project is empty', () async {
    when(mockRepoService.getAllProjects()).thenAnswer((_) async => null);

    final updateResult = await controller.updatePersonalProjectData(0,
      PersonalProject(
        ppid: 'mockId1',
        name: 'Updated Project',
      ),
    );

    expect(updateResult, false);

    verifyNever(pp1.update());
    verifyNever(pp2.update());
  });

    // test('deletePersonalProject deletes an existing personal project', () async {
    //   final mockPersonalProjects = [pp1,pp2];
    //   const indexToDelete = 1;

    //   when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockPersonalProjects);
    //   when(mockPersonalProjects[indexToDelete].delete()).thenAnswer((_) async {});

    //   final deletedResult = await controller.deletePersonalProject(indexToDelete);

    //   expect(deletedResult, isTrue);
    //   verify(mockPersonalProjects[indexToDelete].delete());
    // });

    // test('deletePersonalProject returns false on error', () async {
    //   final mockPersonalProjects = [pp1];
    //   const indexToDelete = 0;

    //   when(mockRepoService.getAllProjects()).thenAnswer((_) async => mockPersonalProjects);
    //   when(mockPersonalProjects[indexToDelete].delete()).thenThrow(Exception('Test Exception'));

    //   final deleteResult = await controller.deletePersonalProject(indexToDelete);

    //   expect(deleteResult, isFalse);
    // });
  }
