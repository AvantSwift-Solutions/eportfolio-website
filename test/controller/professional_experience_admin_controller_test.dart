import 'package:avantswift_portfolio/models/ProfessionalExperience.dart';
import 'package:avantswift_portfolio/reposervice/professional_experience_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controller/admin_controllers/professional_experience_section_admin_controller.dart';
import 'professional_experience_admin_controller.mocks.dart';

@GenerateMocks([ProfessionalExperienceRepoService])
class MockProfessionalExperience extends Mock implements ProfessionalExperience {}

void main() {
  late MockProfessionalExperience mockProfessionalExperience1;
  late MockProfessionalExperience mockProfessionalExperience2;

  late ProfessionalExperienceSectionAdminController controller;
  late ProfessionalExperienceRepoService mockRepoService;

  setUp(() {
    mockProfessionalExperience1 = MockProfessionalExperience();
    when(mockProfessionalExperience1.peid).thenReturn('mockId1');
    when(mockProfessionalExperience1.jobTitle).thenReturn('Mock JobTitle1');
    when(mockProfessionalExperience1.companyName).thenReturn('Mock CompanyName1');
    when(mockProfessionalExperience1.location).thenReturn('Mock Location1');
    when(mockProfessionalExperience1.startDate).thenReturn(Timestamp.now());
    when(mockProfessionalExperience1.endDate).thenReturn(Timestamp.now());
    when(mockProfessionalExperience1.logoURL).thenReturn('http://example.com/mock_image1.jpg');
    when(mockProfessionalExperience1.description).thenReturn('Mock Description1');

    mockProfessionalExperience2 = MockProfessionalExperience();
    when(mockProfessionalExperience2.peid).thenReturn('mockId2');
    when(mockProfessionalExperience2.jobTitle).thenReturn('Mock JobTitle2');
    when(mockProfessionalExperience2.companyName).thenReturn('Mock CompanyName2');
    when(mockProfessionalExperience2.location).thenReturn('Mock Location2');
    when(mockProfessionalExperience2.startDate).thenReturn(Timestamp.now());
    when(mockProfessionalExperience2.endDate).thenReturn(Timestamp.now());
    when(mockProfessionalExperience2.logoURL).thenReturn('http://example.com/mock_image2.jpg');
    when(mockProfessionalExperience2.description).thenReturn('Mock Description2');
    
    mockRepoService = MockProfessionalExperienceRepoService();
    controller = ProfessionalExperienceSectionAdminController(mockRepoService);
  });

  test('getProfessionalExperienceSectionData returns correct data when professional experience is not null',
      () async {

    when(mockRepoService.getAllProfessionalExperiences()).thenAnswer((_) async
      => [mockProfessionalExperience1, mockProfessionalExperience2]);
    final getAllProfessionalExperiences = await controller.getProfessionalExperienceSectionData();

    // Make assertions on the returned data
    expect(getAllProfessionalExperiences!.length, 2);

    var exp1 = getAllProfessionalExperiences[0];
    var exp2 = getAllProfessionalExperiences[1];

    expect(exp1.peid, mockProfessionalExperience1.peid);
    expect(exp1.jobTitle, mockProfessionalExperience1.jobTitle);
    expect(exp1.companyName, mockProfessionalExperience1.companyName);
    expect(exp1.location, mockProfessionalExperience1.location);
    expect(exp1.startDate, mockProfessionalExperience1.startDate);
    expect(exp1.endDate, mockProfessionalExperience1.endDate);
    expect(exp1.logoURL, mockProfessionalExperience1.logoURL);
    expect(exp1.description, mockProfessionalExperience1.description);

    expect(exp2.peid, mockProfessionalExperience2.peid);
    expect(exp2.jobTitle, mockProfessionalExperience2.jobTitle);
    expect(exp2.companyName, mockProfessionalExperience2.companyName);
    expect(exp2.location, mockProfessionalExperience2.location);
    expect(exp2.startDate, mockProfessionalExperience2.startDate);
    expect(exp2.endDate, mockProfessionalExperience2.endDate);
    expect(exp2.logoURL, mockProfessionalExperience2.logoURL);
    expect(exp2.description, mockProfessionalExperience2.description);

  });

  test('getProfessionalExperienceSectionData returns null data when professional experience is null', () async {
    when(mockRepoService.getAllProfessionalExperiences()).thenAnswer((_) async => null);
    final professionalExperienceSectionData = await controller.getProfessionalExperienceSectionData();
    expect(professionalExperienceSectionData, null);
  });

  test('getProfessionalExperienceSectionData returns null data on exception', () async {
    when(mockRepoService.getAllProfessionalExperiences()).thenThrow(Exception('Test Exception'));
    final professionalExperienceSectionData = await controller.getProfessionalExperienceSectionData();
    expect(professionalExperienceSectionData, null);
  });

  test('updateProfessionalExperienceSectionData returns true on successful update', () async {
    when(mockRepoService.getAllProfessionalExperiences()).thenAnswer((_) async
      => [mockProfessionalExperience1, mockProfessionalExperience2]);
    when(mockProfessionalExperience1.update()).thenAnswer((_) async => true);

    final updateResult = await controller.updateProfessionalExperienceSectionData(0,
      ProfessionalExperience(
        peid: 'mockId1',
        jobTitle: 'New Mock JobTitle1',
        companyName: 'New Mock CompanyName1',
        location: 'New Mock Location1',
        startDate: Timestamp(1234567890, 0),
        endDate: Timestamp(1234567890, 0),
        description: 'New Mock Description1',
        logoURL: 'http://example.com/new_mock_image1.jpg',
      ),
    );

    expect(updateResult, true);
    verify(mockProfessionalExperience1.jobTitle = 'New Mock JobTitle1');
    verify(mockProfessionalExperience1.companyName = 'New Mock CompanyName1');
    verify(mockProfessionalExperience1.location = 'New Mock Location1');
    verify(mockProfessionalExperience1.startDate = Timestamp(1234567890, 0));
    verify(mockProfessionalExperience1.endDate = Timestamp(1234567890, 0));
    verify(mockProfessionalExperience1.description = 'New Mock Description1');
    verify(mockProfessionalExperience1.logoURL = 'http://example.com/new_mock_image1.jpg');

    verify(mockProfessionalExperience1.update()); // Verify that the method was called
  });

  test('updateProfessionalExperienceSectionData returns false when user is null', () async {
    when(mockRepoService.getAllProfessionalExperiences()).thenAnswer((_) async => null);

    final updateResult = await controller.updateProfessionalExperienceSectionData(0,
      ProfessionalExperience(
        peid: 'mockId1',
        jobTitle: 'New Mock JobTitle1',
        companyName: 'New Mock CompanyName1',
        location: 'New Mock Location1',
        startDate: Timestamp(1234567890, 0),
        endDate: Timestamp(1234567890, 0),
        description: 'New Mock Description1',
        logoURL: 'http://example.com/new_mock_image1.jpg',
      ),
    );

    expect(updateResult, false);

    verifyNever(mockProfessionalExperience1.update());
    verifyNever(mockProfessionalExperience2.update());
  });
}