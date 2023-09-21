import 'package:avantswift_portfolio/controllers/view_controllers/education_section_controller.dart';
import 'package:avantswift_portfolio/dto/education_section_dto.dart';
import 'package:avantswift_portfolio/models/Education.dart';
import 'package:avantswift_portfolio/reposervice/education_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/education_section_controller_test.mocks.dart';

class MockEducation extends Mock implements Education {}

@GenerateMocks([EducationRepoService, Education])
void main() {
  group('EducationController Tests', () {
    late EducationSectionController controller;
    late MockEducationRepoService mockRepoService;
    late MockEducation mockEducation1;
    late MockEducation mockEducation2;

    setUp(() {
      mockEducation1 = MockEducation();
      when(mockEducation1.eid).thenReturn('1');
      when(mockEducation1.startDate)
          .thenReturn(Timestamp.fromDate(DateTime(2022, 1, 1)));
      when(mockEducation1.endDate)
          .thenReturn(Timestamp.fromDate(DateTime(2022, 12, 31)));
      when(mockEducation1.logoURL)
          .thenReturn('http://example.com/mock_image1.jpg');
      when(mockEducation1.schoolName).thenReturn('Mock School 1');
      when(mockEducation1.degree).thenReturn('Mock Degree 1');
      when(mockEducation1.description).thenReturn('Mock Description 1');
      when(mockEducation1.gradeDescription)
          .thenReturn('Mock Grade Description 1');
      when(mockEducation1.index).thenReturn(1);
      when(mockEducation1.grade).thenReturn(95);
      when(mockEducation1.major).thenReturn('Mock Major 1');

      mockEducation2 = MockEducation();
      when(mockEducation2.eid).thenReturn('2');
      when(mockEducation2.startDate)
          .thenReturn(Timestamp.fromDate(DateTime(2021, 1, 1)));
      when(mockEducation2.endDate).thenReturn(null);
      when(mockEducation2.logoURL)
          .thenReturn('http://example.com/mock_image1.jpg');
      when(mockEducation2.schoolName).thenReturn('Mock School 2');
      when(mockEducation2.degree).thenReturn('Mock Degree 2');
      when(mockEducation2.description).thenReturn('Mock Description 2');
      when(mockEducation2.gradeDescription)
          .thenReturn('Mock Grade Description 2');
      when(mockEducation2.index).thenReturn(2);
      when(mockEducation2.grade).thenReturn(90);
      when(mockEducation2.major).thenReturn('Mock Major 2');

      mockRepoService = MockEducationRepoService();
      controller = EducationSectionController(mockRepoService);
    });

    test('getAllEducation returns a list of EducationDTOs', () async {
      // ignore: non_constant_identifier_names
      final EducationList = [
        Education(
          eid: '1',
          startDate: Timestamp.fromDate(DateTime(2022, 1, 1)),
          endDate: Timestamp.fromDate(DateTime(2022, 12, 31)),
          logoURL: 'http://example.com/mock_image1.jpg',
          schoolName: 'Mock School 1',
          degree: 'Mock Degree 1',
          description: 'Mock Description 1',
          gradeDescription: 'Mock Grade Description 1',
          index: 1,
          grade: 95,
          major: 'Mock Major 1',
        ),
        Education(
          eid: '2',
          startDate: Timestamp.fromDate(DateTime(2021, 1, 1)),
          endDate: null,
          logoURL: 'http://example.com/mock_image1.jpg',
          schoolName: 'Mock School 2',
          degree: 'Mock Degree 2',
          description: 'Mock Description 2',
          gradeDescription: 'Mock Grade Description 2',
          index: 2,
          grade: 90,
          major: 'Mock Major 2',
        ),
      ];

      when(mockRepoService.getAllEducation())
          .thenAnswer((_) async => EducationList);

      final educationDTOList = await controller.getEducationSectionData();

      expect(educationDTOList!.length, 2);

      var educationDTO1 = educationDTOList[0];
      var educationDTO2 = educationDTOList[1];

      expect(educationDTO1.schoolName, mockEducation1.schoolName);
      expect(educationDTO1.startDate, "Jan 2022");
      expect(educationDTO1.endDate, "Dec 2022");
      expect(educationDTO1.degree, mockEducation1.degree);
      expect(educationDTO1.description, mockEducation1.description);
      expect(educationDTO1.logoURL, mockEducation1.logoURL);
      expect(educationDTO1.grade, mockEducation1.grade);
      expect(educationDTO1.gradeDescription, mockEducation1.gradeDescription);
      expect(educationDTO1.index, mockEducation1.index);
      expect(educationDTO1.major, mockEducation1.major);

      expect(educationDTO2.schoolName, mockEducation2.schoolName);
      expect(educationDTO2.startDate, "Jan 2021");
      expect(educationDTO2.endDate, "Present");
      expect(educationDTO2.degree, mockEducation2.degree);
      expect(educationDTO2.description, mockEducation2.description);
      expect(educationDTO2.logoURL, mockEducation2.logoURL);
      expect(educationDTO2.grade, mockEducation2.grade);
      expect(educationDTO2.gradeDescription, mockEducation2.gradeDescription);
      expect(educationDTO2.index, mockEducation2.index);
      expect(educationDTO2.major, mockEducation2.major);

      verify(mockRepoService.getAllEducation());
    });

    test('getAllEducation returns default data when EducationList is null',
        () async {
      when(mockRepoService.getAllEducation()).thenAnswer((_) async => null);
      final educationDTOList = await controller.getEducationSectionData();

      expect(educationDTOList!.length, 1);

      var educationDTOUnknown = educationDTOList[0];

      expect(educationDTOUnknown.schoolName, 'unknown');
      expect(educationDTOUnknown.startDate, 'unknown');
      expect(educationDTOUnknown.endDate, 'unknown');
      expect(educationDTOUnknown.degree, 'unknown');
      expect(educationDTOUnknown.description, 'unknown');
      expect(educationDTOUnknown.logoURL, 'unknown');
      expect(educationDTOUnknown.grade, -1);
      expect(educationDTOUnknown.gradeDescription, 'unknown');
      expect(educationDTOUnknown.index, -1);
      expect(educationDTOUnknown.major, 'unknown');
    });

    test('getAllEducation returns error data on exception',
        () async {
      when(mockRepoService.getAllEducation())
          .thenThrow(Exception('Test Exception'));
      final educationDTOList = await controller.getEducationSectionData();

      expect(educationDTOList!.length, 1);

      var educationDTOError = educationDTOList[0];

      expect(educationDTOError.schoolName, 'Error');
      expect(educationDTOError.startDate, 'Error');
      expect(educationDTOError.endDate, 'Error');
      expect(educationDTOError.degree, 'Error');
      expect(educationDTOError.description, 'Error');
      expect(educationDTOError.logoURL, 'Error');
      expect(educationDTOError.grade, -2);
      expect(educationDTOError.gradeDescription, 'Error');
      expect(educationDTOError.index, -2);
      expect(educationDTOError.major, 'Error');
    });
  });
}
