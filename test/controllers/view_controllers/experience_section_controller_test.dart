import 'package:avantswift_portfolio/controllers/view_controllers/experience_section_controller.dart';
import 'package:avantswift_portfolio/models/Education.dart';
import 'package:avantswift_portfolio/models/Experience.dart';
import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/experience_section_controller_test.mocks.dart';

// class MockEducation extends Mock implements Education {}

@GenerateMocks([ExperienceRepoService, Experience])
void main() {
  group('EducationController Tests', () {
    late ExperienceSectionController controller;
    late MockExperienceRepoService mockRepoService;
    late MockExperience mockExperience1;
    late MockExperience mockExperience2;

    setUp(() {
      mockExperience1 = MockExperience();
      when(mockExperience1.peid).thenReturn('mockId1');
      when(mockExperience1.jobTitle).thenReturn('Mock Job Title 1');
      when(mockExperience1.companyName).thenReturn('Mock Company Name 1');
      when(mockExperience1.location).thenReturn('Mock Location 1');
      when(mockExperience1.startDate)
          .thenReturn(Timestamp.fromDate(DateTime(2022, 1, 1)));
      when(mockExperience1.endDate)
          .thenReturn(Timestamp.fromDate(DateTime(2022, 12, 31)));
      when(mockExperience1.logoURL)
          .thenReturn('http://example.com/mock_image1.jpg');
      when(mockExperience1.description).thenReturn('Mock Description 1');
      when(mockExperience1.index).thenReturn(1);

      mockExperience2 = MockExperience();
      when(mockExperience2.peid).thenReturn('mockId2');
      when(mockExperience2.startDate)
          .thenReturn(Timestamp.fromDate(DateTime(2021, 1, 1)));
      when(mockExperience2.endDate).thenReturn(null);
      when(mockExperience2.logoURL)
          .thenReturn('http://example.com/mock_image2.jpg');
      when(mockExperience2.jobTitle).thenReturn('Mock Job Title 2');
      when(mockExperience2.companyName).thenReturn('Mock Company Name 2');
      when(mockExperience2.location).thenReturn('Mock Location 2');
      when(mockExperience2.description).thenReturn('Mock Description 2');
      when(mockExperience2.index).thenReturn(2);

      mockRepoService = MockExperienceRepoService();
      controller = ExperienceSectionController(mockRepoService);
    });

    test('getAllEducation returns a list of EducationDTOs', () async {
      // ignore: non_constant_identifier_names
      final ExperienceList = [
        Experience(
          peid: 'mockId1',
          startDate: Timestamp.fromDate(DateTime(2022, 1, 1)),
          endDate: Timestamp.fromDate(DateTime(2022, 12, 31)),
          logoURL: 'http://example.com/mock_image1.jpg',
          jobTitle: 'Mock Job Title 1',
          companyName: 'Mock Company Name 1',
          location: 'Mock Location 1',
          description: 'Mock Description 1',
          index: 1,
        ),
        Experience(
          peid: 'mockId2',
          startDate: Timestamp.fromDate(DateTime(2021, 1, 1)),
          endDate: null,
          logoURL: 'http://example.com/mock_image2.jpg',
          jobTitle: 'Mock Job Title 2',
          companyName: 'Mock Company Name 2',
          location: 'Mock Location 2',
          description: 'Mock Description 2',
          index: 2,
        ),
      ];

      when(mockRepoService.getAllExperiences())
          .thenAnswer((_) async => ExperienceList);

      final experienceDTOList = await controller.getExperienceSectionData();

      expect(experienceDTOList!.length, 2);

      var experienceDTO1 = experienceDTOList[0];
      var experienceDTO2 = experienceDTOList[1];

      expect(experienceDTO1.companyName, mockExperience1.companyName);
      expect(experienceDTO1.jobTitle, mockExperience1.jobTitle);
      expect(experienceDTO1.startDate, "Jan 2022");
      expect(experienceDTO1.endDate, "Dec 2022");
      expect(experienceDTO1.location, mockExperience1.location);
      expect(experienceDTO1.description, mockExperience1.description);
      expect(experienceDTO1.logoURL, mockExperience1.logoURL);

      expect(experienceDTO2.companyName, mockExperience2.companyName);
      expect(experienceDTO2.jobTitle, mockExperience2.jobTitle);
      expect(experienceDTO2.startDate, "Jan 2021");
      expect(experienceDTO2.endDate, "Present");
      expect(experienceDTO2.location, mockExperience2.location);
      expect(experienceDTO2.description, mockExperience2.description);
      expect(experienceDTO2.logoURL, mockExperience2.logoURL);

      verify(mockRepoService.getAllExperiences());
    });

    test('getAllEexperience returns default data when Experience is null',
        () async {
      when(mockRepoService.getAllExperiences()).thenAnswer((_) async => null);
      final experienceDTOList = await controller.getExperienceSectionData();

      expect(experienceDTOList!.length, 1);

      var experienceDTOUnknown = experienceDTOList[0];

      expect(experienceDTOUnknown.companyName, 'unknown');
      expect(experienceDTOUnknown.jobTitle, 'unknown');
      expect(experienceDTOUnknown.startDate, 'unknown');
      expect(experienceDTOUnknown.endDate, 'unknown');
      expect(experienceDTOUnknown.location, 'unknown');
      expect(experienceDTOUnknown.description, 'unknown');
      expect(experienceDTOUnknown.logoURL, 'unknown');
    });

    // test('getAllEducation returns error data on exception', () async {
    //   when(mockRepoService.getAllEducation())
    //       .thenThrow(Exception('Test Exception'));
    //   final educationDTOList = await controller.getEducationSectionData();

    //   expect(educationDTOList!.length, 1);

    //   var educationDTOError = educationDTOList[0];

    //   expect(educationDTOError.schoolName, 'Error');
    //   expect(educationDTOError.startDate, 'Error');
    //   expect(educationDTOError.endDate, 'Error');
    //   expect(educationDTOError.degree, 'Error');
    //   expect(educationDTOError.description, 'Error');
    //   expect(educationDTOError.logoURL, 'Error');
    //   expect(educationDTOError.grade, -2);
    //   expect(educationDTOError.gradeDescription, 'Error');
    //   expect(educationDTOError.index, -2);
    //   expect(educationDTOError.major, 'Error');
    // });
  });
}
