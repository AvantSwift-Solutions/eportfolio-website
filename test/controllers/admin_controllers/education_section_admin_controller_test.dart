import 'package:avantswift_portfolio/models/Education.dart';
import 'package:avantswift_portfolio/reposervice/education_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/education_section_admin_controller.dart';
import 'package:tuple/tuple.dart';
import 'mocks/education_section_admin_controller_test.mocks.dart';

@GenerateMocks([EducationRepoService])
class MockEducation extends Mock implements Education {}

void main() {
  late MockEducation mockEducation1;
  late MockEducation mockEducation2;

  late EducationSectionAdminController controller;
  late MockEducationRepoService mockRepoService;

  setUp(() {
    mockEducation1 = MockEducation();
    when(mockEducation1.creationTimestamp).thenReturn(Timestamp.now());
    when(mockEducation1.eid).thenReturn('mockEid1');
    when(mockEducation1.index).thenReturn(0);
    when(mockEducation1.startDate).thenReturn(Timestamp.now());
    when(mockEducation1.endDate).thenReturn(Timestamp.now());
    when(mockEducation1.logoURL)
        .thenReturn('http://example.com/mock_image1.jpg');
    when(mockEducation1.schoolName).thenReturn('Mock School1');
    when(mockEducation1.degree).thenReturn('Mock Degree1');
    when(mockEducation1.description).thenReturn('Mock Description1');
    when(mockEducation1.major).thenReturn('Mock Major1');
    when(mockEducation1.grade).thenReturn(90);
    when(mockEducation1.gradeDescription).thenReturn('Mock Grade Description1');

    mockEducation2 = MockEducation();
    when(mockEducation2.creationTimestamp).thenReturn(Timestamp.now());
    when(mockEducation2.eid).thenReturn('mockEid2');
    when(mockEducation2.index).thenReturn(1);
    when(mockEducation2.startDate).thenReturn(Timestamp.now());
    when(mockEducation2.endDate).thenReturn(Timestamp.now());
    when(mockEducation2.logoURL)
        .thenReturn('http://example.com/mock_image2.jpg');
    when(mockEducation2.schoolName).thenReturn('Mock School2');
    when(mockEducation2.degree).thenReturn('Mock Degree2');
    when(mockEducation2.description).thenReturn('Mock Description2');
    when(mockEducation2.major).thenReturn('Mock Major2');
    when(mockEducation2.grade).thenReturn(80);
    when(mockEducation2.gradeDescription).thenReturn('Mock Grade Description2');

    mockRepoService = MockEducationRepoService();
    controller = EducationSectionAdminController(mockRepoService);
  });

  group('Education section admin controller tests', () {
    test('getSectionData returns correct data when education is not null',
        () async {
      when(mockRepoService.getAllEducation())
          .thenAnswer((_) async => [mockEducation1, mockEducation2]);
      final allEducation = await controller.getSectionData();

      // Make assertions on the returned data
      expect(allEducation!.length, 2);

      var edu1 = allEducation[0];
      var edu2 = allEducation[1];

      expect(edu1.creationTimestamp, mockEducation1.creationTimestamp);
      expect(edu1.eid, mockEducation1.eid);
      expect(edu1.index, mockEducation1.index);
      expect(edu1.startDate, mockEducation1.startDate);
      expect(edu1.endDate, mockEducation1.endDate);
      expect(edu1.logoURL, mockEducation1.logoURL);
      expect(edu1.schoolName, mockEducation1.schoolName);
      expect(edu1.degree, mockEducation1.degree);
      expect(edu1.description, mockEducation1.description);
      expect(edu1.major, mockEducation1.major);
      expect(edu1.grade, mockEducation1.grade);
      expect(edu1.gradeDescription, mockEducation1.gradeDescription);

      expect(edu2.creationTimestamp, mockEducation2.creationTimestamp);
      expect(edu2.eid, mockEducation2.eid);
      expect(edu2.index, mockEducation2.index);
      expect(edu2.startDate, mockEducation2.startDate);
      expect(edu2.endDate, mockEducation2.endDate);
      expect(edu2.logoURL, mockEducation2.logoURL);
      expect(edu2.schoolName, mockEducation2.schoolName);
      expect(edu2.degree, mockEducation2.degree);
      expect(edu2.description, mockEducation2.description);
      expect(edu2.major, mockEducation2.major);
      expect(edu2.grade, mockEducation2.grade);
      expect(edu2.gradeDescription, mockEducation2.gradeDescription);
    });

    test('getSectionData returns null data when education is null', () async {
      when(mockRepoService.getAllEducation()).thenAnswer((_) async => null);
      final educationSectionData = await controller.getSectionData();
      expect(educationSectionData, null);
    });

    test('getSectionData returns null data on exception', () async {
      when(mockRepoService.getAllEducation())
          .thenThrow(Exception('Test Exception'));
      final educationSectionData = await controller.getSectionData();
      expect(educationSectionData, null);
    });

    test('getSectionName returns correct name', () {
      expect(controller.getSectionName(), 'Educations');
    });

    test('returns empty list when section data is null', () async {
      when(controller.getSectionData()).thenAnswer((_) => Future.value(null));
      final titles = await controller.getSectionTitles();
      expect(titles, isEmpty);
    });

    test('returns list of titles when section data is not null', () async {
      when(controller.getSectionData())
          .thenAnswer((_) => Future.value([mockEducation1, mockEducation2]));
      final titles = await controller.getSectionTitles();
      expect(titles, [
        Tuple2(mockEducation1.index,
            '${mockEducation1.degree} at ${mockEducation1.schoolName}'),
        Tuple2(mockEducation2.index,
            '${mockEducation2.degree} at ${mockEducation2.schoolName}'),
      ]);
    });

    test('updateSectionOrder should update the indicies', () async {
      final items = [
        const Tuple2<int, String>(0, 'item1'),
        const Tuple2<int, String>(1, 'item2')
      ];
      final exps = [mockEducation1, mockEducation2];
      when(controller.getSectionData()).thenAnswer((_) async => exps);
      when(mockEducation1.update()).thenAnswer((_) async => true);
      when(mockEducation2.update()).thenAnswer((_) async => true);

      await controller.updateSectionOrder(items);

      verifyInOrder([
        mockEducation1.index = 0,
        mockEducation1.update(),
        mockEducation2.index = 1,
        mockEducation2.update(),
      ]);
    });

    test('defaultOrderName should return correctly', () {
      expect(controller.defaultOrderName(), 'by End Date');
    });

    test('applyDefaultOrder should sort objects in default order', () async {
      final list = [mockEducation1, mockEducation2];
      when(controller.getSectionData()).thenAnswer((_) async => list);
      when(mockEducation1.endDate)
          .thenReturn(Timestamp.fromMicrosecondsSinceEpoch(1));
      when(mockEducation2.endDate)
          .thenReturn(Timestamp.fromMicrosecondsSinceEpoch(2));
      when(mockEducation1.update()).thenAnswer((_) async => true);
      when(mockEducation2.update()).thenAnswer((_) async => false);

      await controller.applyDefaultOrder();

      expect(list[0].endDate, Timestamp.fromMicrosecondsSinceEpoch(2));
      expect(list[1].endDate, Timestamp.fromMicrosecondsSinceEpoch(1));
    });

    test(
        'deleteData should delete object at given index and update the index of remaining objects',
        () async {
      final list = [mockEducation1, mockEducation2];
      when(mockEducation1.index).thenReturn(0);
      when(mockEducation2.index).thenReturn(1);
      when(mockEducation1.update()).thenAnswer((_) async => true);
      when(mockEducation1.delete()).thenAnswer((_) async => true);
      when(mockEducation2.update()).thenAnswer((_) async => true);
      when(mockEducation2.delete()).thenAnswer((_) async => true);

      final result = await controller.deleteData(list, 0);

      verifyInOrder([
        mockEducation2.index = 0,
        mockEducation2.update(),
        mockEducation1.delete(),
      ]);
      expect(list[0].index, 0);
      expect(result, true);
    });

    test('deleteData should return false if deleting object fails', () async {
      final list = [mockEducation1];
      when(mockEducation1.delete()).thenThrow(Exception());

      final result = await controller.deleteData(list, 0);

      expect(result, false);
    });
  });
}
