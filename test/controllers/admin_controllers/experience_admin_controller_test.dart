import 'package:avantswift_portfolio/models/Experience.dart';
import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/experience_section_admin_controller.dart';
import 'package:tuple/tuple.dart';
import 'mocks/experience_admin_controller_test.mocks.dart';

@GenerateMocks([ExperienceRepoService])
class MockExperience extends Mock implements Experience {}

void main() {
  late MockExperience mockExperience1;
  late MockExperience mockExperience2;

  late ExperienceSectionAdminController controller;
  late ExperienceRepoService mockRepoService;

  setUp(() {
    mockExperience1 = MockExperience();
    when(mockExperience1.creationTimestamp).thenReturn(Timestamp.now());
    when(mockExperience1.peid).thenReturn('mockId1');
    when(mockExperience1.index).thenReturn(1);
    when(mockExperience1.jobTitle).thenReturn('Mock JobTitle1');
    when(mockExperience1.employmentType).thenReturn('Mock EmploymentType1');
    when(mockExperience1.companyName).thenReturn('Mock CompanyName1');
    when(mockExperience1.location).thenReturn('Mock Location1');
    when(mockExperience1.startDate).thenReturn(Timestamp.now());
    when(mockExperience1.endDate).thenReturn(Timestamp.now());
    when(mockExperience1.logoURL)
        .thenReturn('http://example.com/mock_image1.jpg');
    when(mockExperience1.description).thenReturn('Mock Description1');

    mockExperience2 = MockExperience();
    when(mockExperience2.creationTimestamp).thenReturn(Timestamp.now());
    when(mockExperience2.peid).thenReturn('mockId2');
    when(mockExperience2.index).thenReturn(2);
    when(mockExperience2.jobTitle).thenReturn('Mock JobTitle2');
    when(mockExperience2.employmentType).thenReturn('Mock EmploymentType2');
    when(mockExperience2.companyName).thenReturn('Mock CompanyName2');
    when(mockExperience2.location).thenReturn('Mock Location2');
    when(mockExperience2.startDate).thenReturn(Timestamp.now());
    when(mockExperience2.endDate).thenReturn(Timestamp.now());
    when(mockExperience2.logoURL)
        .thenReturn('http://example.com/mock_image2.jpg');
    when(mockExperience2.description).thenReturn('Mock Description2');

    mockRepoService = MockExperienceRepoService();
    controller = ExperienceSectionAdminController(mockRepoService);
  });

  group('Experience section admin controller tests', () {
    test('getSectionData returns correct data when  experience is not null',
        () async {
      when(mockRepoService.getAllExperiences())
          .thenAnswer((_) async => [mockExperience1, mockExperience2]);
      final getAllExperiences = await controller.getSectionData();

      // Make assertions on the returned data
      expect(getAllExperiences!.length, 2);

      var exp1 = getAllExperiences[0];
      var exp2 = getAllExperiences[1];

      expect(exp1.creationTimestamp, mockExperience1.creationTimestamp);
      expect(exp1.peid, mockExperience1.peid);
      expect(exp1.index, mockExperience1.index);
      expect(exp1.jobTitle, mockExperience1.jobTitle);
      expect(exp1.employmentType, mockExperience1.employmentType);
      expect(exp1.companyName, mockExperience1.companyName);
      expect(exp1.location, mockExperience1.location);
      expect(exp1.startDate, mockExperience1.startDate);
      expect(exp1.endDate, mockExperience1.endDate);
      expect(exp1.logoURL, mockExperience1.logoURL);
      expect(exp1.description, mockExperience1.description);

      expect(exp2.creationTimestamp, mockExperience2.creationTimestamp);
      expect(exp2.peid, mockExperience2.peid);
      expect(exp2.index, mockExperience2.index);
      expect(exp2.jobTitle, mockExperience2.jobTitle);
      expect(exp2.employmentType, mockExperience2.employmentType);
      expect(exp2.companyName, mockExperience2.companyName);
      expect(exp2.location, mockExperience2.location);
      expect(exp2.startDate, mockExperience2.startDate);
      expect(exp2.endDate, mockExperience2.endDate);
      expect(exp2.logoURL, mockExperience2.logoURL);
      expect(exp2.description, mockExperience2.description);
    });

    test('getSectionData returns null data when  experience is null', () async {
      when(mockRepoService.getAllExperiences()).thenAnswer((_) async => null);
      final experienceSectionData = await controller.getSectionData();
      expect(experienceSectionData, null);
    });

    test('getSectionData returns null data on exception', () async {
      when(mockRepoService.getAllExperiences())
          .thenThrow(Exception('Test Exception'));
      final experienceSectionData = await controller.getSectionData();
      expect(experienceSectionData, null);
    });

    test('getSectionName returns correct name', () {
      expect(controller.getSectionName(), 'Professional Experiences');
    });

    test('returns empty list when section data is null', () async {
      when(controller.getSectionData()).thenAnswer((_) => Future.value(null));
      final titles = await controller.getSectionTitles();
      expect(titles, isEmpty);
    });

    test('returns list of titles when section data is not null', () async {
      when(controller.getSectionData())
          .thenAnswer((_) => Future.value([mockExperience1, mockExperience2]));
      final titles = await controller.getSectionTitles();
      expect(titles, [
        Tuple2(mockExperience1.index,
            '${mockExperience1.jobTitle} at ${mockExperience1.companyName}'),
        Tuple2(mockExperience2.index,
            '${mockExperience2.jobTitle} at ${mockExperience2.companyName}'),
      ]);
    });

    test('updateSectionOrder should update the indicies', () async {
      final items = [
        const Tuple2<int, String>(0, 'item1'),
        const Tuple2<int, String>(1, 'item2')
      ];
      final exps = [mockExperience1, mockExperience2];
      when(controller.getSectionData()).thenAnswer((_) async => exps);
      when(mockExperience1.update()).thenAnswer((_) async => true);
      when(mockExperience2.update()).thenAnswer((_) async => true);

      await controller.updateSectionOrder(items);

      verifyInOrder([
        mockExperience1.index = 0,
        mockExperience1.update(),
        mockExperience2.index = 1,
        mockExperience2.update(),
      ]);
    });

    test('defaultOrderName should return correctly', () {
      expect(controller.defaultOrderName(), 'by End Date');
    });

    test('applyDefaultOrder should sort objects in default order', () async {
      MockExperience mockExperience3 = MockExperience();
      final list = [mockExperience3, mockExperience1, mockExperience2];
      when(controller.getSectionData()).thenAnswer((_) async => list);
      when(mockExperience1.endDate)
          .thenReturn(Timestamp.fromMicrosecondsSinceEpoch(1));
      when(mockExperience2.endDate)
          .thenReturn(Timestamp.fromMicrosecondsSinceEpoch(2));
      when(mockExperience3.endDate).thenReturn(null);
      when(mockExperience1.update()).thenAnswer((_) async => true);
      when(mockExperience2.update()).thenAnswer((_) async => false);

      await controller.applyDefaultOrder();

      expect(list[0].endDate, null);
      expect(list[1].endDate, Timestamp.fromMicrosecondsSinceEpoch(2));
      expect(list[2].endDate, Timestamp.fromMicrosecondsSinceEpoch(1));
    });

    test(
        'deleteData should delete object at given index and update the index of remaining objects',
        () async {
      final list = [mockExperience1, mockExperience2];
      when(mockExperience1.index).thenReturn(0);
      when(mockExperience2.index).thenReturn(1);
      when(mockExperience1.update()).thenAnswer((_) async => true);
      when(mockExperience1.delete()).thenAnswer((_) async => true);
      when(mockExperience2.update()).thenAnswer((_) async => true);
      when(mockExperience2.delete()).thenAnswer((_) async => true);

      final result = await controller.deleteData(list, 0);

      verifyInOrder([
        mockExperience2.index = 0,
        mockExperience2.update(),
        mockExperience1.delete(),
      ]);
      expect(list[0].index, 0);
      expect(result, true);
    });

    test('deleteData should return false if deleting object fails', () async {
      final list = [mockExperience1];
      when(mockExperience1.delete()).thenThrow(Exception());

      final result = await controller.deleteData(list, 0);

      expect(result, false);
    });
  });
}
