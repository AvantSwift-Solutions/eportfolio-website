import 'package:avantswift_portfolio/models/Education.dart';
import 'package:avantswift_portfolio/reposervice/education_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controller/admin_controllers/education_section_admin_controller.dart';
import 'education_section_admin_controller_test.mocks.dart';

@GenerateMocks([EducationRepoService])
class MockEducation extends Mock implements Education {}

void main() {
  late MockEducation mockEducation1;
  late MockEducation mockEducation2;

  late EducationSectionAdminController controller;
  late MockEducationRepoService mockRepoService;

  setUp(() {
    mockEducation1 = MockEducation();
    when(mockEducation1.eid).thenReturn('mockEid1');
    when(mockEducation1.startDate).thenReturn(Timestamp.now());
    when(mockEducation1.endDate).thenReturn(Timestamp.now());
    when(mockEducation1.logoURL).thenReturn('http://example.com/mock_image1.jpg');
    when(mockEducation1.schoolName).thenReturn('Mock School1');
    when(mockEducation1.degree).thenReturn('Mock Degree1');
    when(mockEducation1.description).thenReturn('Mock Description1');

    mockEducation2 = MockEducation();
    when(mockEducation2.eid).thenReturn('mockEid2');
    when(mockEducation2.startDate).thenReturn(Timestamp.now());
    when(mockEducation2.endDate).thenReturn(Timestamp.now());
    when(mockEducation2.logoURL).thenReturn('http://example.com/mock_image2.jpg');
    when(mockEducation2.schoolName).thenReturn('Mock School2');
    when(mockEducation2.degree).thenReturn('Mock Degree2');
    when(mockEducation2.description).thenReturn('Mock Description2');
    
    mockRepoService = MockEducationRepoService();
    controller = EducationSectionAdminController(mockRepoService);
  });

  test('getEducationSectionData returns correct data when education is not null',
      () async {

    when(mockRepoService.getAllEducation()).thenAnswer((_) async
      => [mockEducation1, mockEducation2]);
    final allEducation = await controller.getEducationSectionData();

    // Make assertions on the returned data
    expect(allEducation!.length, 2);

    var edu1 = allEducation[0];
    var edu2 = allEducation[1];

    expect(edu1.eid, mockEducation1.eid);
    expect(edu1.startDate, mockEducation1.startDate);
    expect(edu1.endDate, mockEducation1.endDate);
    expect(edu1.logoURL, mockEducation1.logoURL);
    expect(edu1.schoolName, mockEducation1.schoolName);
    expect(edu1.degree, mockEducation1.degree);
    expect(edu1.description, mockEducation1.description);

    expect(edu2.eid, mockEducation2.eid);
    expect(edu2.startDate, mockEducation2.startDate);
    expect(edu2.endDate, mockEducation2.endDate);
    expect(edu2.logoURL, mockEducation2.logoURL);
    expect(edu2.schoolName, mockEducation2.schoolName);
    expect(edu2.degree, mockEducation2.degree);
    expect(edu2.description, mockEducation2.description);

  });

  test('getEducationSectionData returns null data when education is null', () async {
    when(mockRepoService.getAllEducation()).thenAnswer((_) async => null);
    final educationSectionData = await controller.getEducationSectionData();
    expect(educationSectionData, null);
  });

  test('getEducationSectionData returns null data on exception', () async {
    when(mockRepoService.getAllEducation()).thenThrow(Exception('Test Exception'));
    final educationSectionData = await controller.getEducationSectionData();
    expect(educationSectionData, null);
  });

}
