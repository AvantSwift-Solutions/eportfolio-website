import 'package:avantswift_portfolio/models/Reccomendation.dart';
import 'package:avantswift_portfolio/reposervice/reccomendation_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controller/admin_controllers/reccomendation_section_admin_controller.dart';
import 'reccomendation_section_admin_controller_test.mocks.dart';

@GenerateMocks([ReccomendationRepoService])
class MockReccomendation extends Mock implements Reccomendation {}

void main() {
  late MockReccomendation mockReccomendation1;
  late MockReccomendation mockReccomendation2;

  late ReccomendationSectionAdminController controller;
  late ReccomendationRepoService mockRepoService;

  setUp(() {
    mockReccomendation1 = MockReccomendation();
    when(mockReccomendation1.reccomendationId).thenReturn('edu123');
    when(mockReccomendation1.colleagueName).thenReturn('Steve Jobs');
    when(mockReccomendation1.colleagueJobTitle).thenReturn('CEO');
    when(mockReccomendation1.description).thenReturn('This is a reccomendation');
    when(mockReccomendation1.imageURL).thenReturn('http://example.com/mock_image1.jpg');

    mockReccomendation2 = MockReccomendation();
    when(mockReccomendation2.reccomendationId).thenReturn('edu321');
    when(mockReccomendation2.colleagueName).thenReturn('ColleagueName2');
    when(mockReccomendation2.colleagueJobTitle).thenReturn('ColleagueJobTitle2');
    when(mockReccomendation2.description).thenReturn('This is a reccomendation2');
    when(mockReccomendation2.imageURL).thenReturn('http://example.com/mock_image2.jpg');
    
    mockRepoService = MockReccomendationRepoService();
    controller = ReccomendationSectionAdminController(mockRepoService);
  });

  test('getReccomendationSectionData returns correct data when reccomendation is not null',
      () async {

    when(mockRepoService.getAllReccomendations()).thenAnswer((_) async
      => [mockReccomendation1, mockReccomendation2]);
    final allReccomendations = await controller.getReccomendationSectionData();

    // Make assertions on the returned data
    expect(allReccomendations!.length, 2);

    var recc1 = allReccomendations[0];
    var recc2 = allReccomendations[1];

    expect(recc1.reccomendationId, mockReccomendation1.reccomendationId);
    expect(recc1.colleagueName, mockReccomendation1.colleagueName);
    expect(recc1.colleagueJobTitle, mockReccomendation1.colleagueJobTitle);
    expect(recc1.description, mockReccomendation1.description);
    expect(recc1.imageURL, mockReccomendation1.imageURL);

    expect(recc2.reccomendationId, mockReccomendation2.reccomendationId);
    expect(recc2.colleagueName, mockReccomendation2.colleagueName);
    expect(recc2.colleagueJobTitle, mockReccomendation2.colleagueJobTitle);
    expect(recc2.description, mockReccomendation2.description);
    expect(recc2.imageURL, mockReccomendation2.imageURL);

  });

  test('getReccomendationSectionData returns null data when reccomendation is null', () async {
    when(mockRepoService.getAllReccomendations()).thenAnswer((_) async => null);
    final reccomendationSectionData = await controller.getReccomendationSectionData();
    expect(reccomendationSectionData, null);
  });

  test('getReccomendationSectionData returns null data on exception', () async {
    when(mockRepoService.getAllReccomendations()).thenThrow(Exception('Test Exception'));
    final reccomendationSectionData = await controller.getReccomendationSectionData();
    expect(reccomendationSectionData, null);
  });

  test('getReccomendationSectionData returns true on successful update', () async {
    when(mockRepoService.getAllReccomendations()).thenAnswer((_) async
      => [mockReccomendation1, mockReccomendation2]);
    when(mockReccomendation1.update()).thenAnswer((_) async => true);

    final updateResult = await controller.updateReccomendationSectionData(0,
      Reccomendation(
        reccomendationId: 'mockReccId1',
        colleagueName: 'New Mock Colleague Name1',
        colleagueJobTitle: 'New Mock Colleague Job Title1',
        description: 'New Mock Description1',
        imageURL: 'http://example.com/new_mock_image1.jpg',
      ),
    );

    expect(updateResult, true);
    verify(mockReccomendation1.colleagueName = 'New Mock Colleague Name1');
    verify(mockReccomendation1.colleagueJobTitle = 'New Mock Colleague Job Title1');
    verify(mockReccomendation1.description = 'New Mock Description1');
    verify(mockReccomendation1.imageURL = 'http://example.com/new_mock_image1.jpg');

    verify(mockReccomendation1.update()); // Verify that the method was called
  });

  test('updateReccomendationSectionData returns false when user is null', () async {
    when(mockRepoService.getAllReccomendations()).thenAnswer((_) async => null);

    final updateResult = await controller.updateReccomendationSectionData(0,
      Reccomendation(
        reccomendationId: 'mockReccId1',
        colleagueName: 'New Mock Colleague Name1',
        colleagueJobTitle: 'New Mock Colleague Job Title1',
        description: 'New Mock Description1',
        imageURL: 'http://example.com/new_mock_image1.jpg',
      ),
    );

    expect(updateResult, false);

    verifyNever(mockReccomendation1.update());
    verifyNever(mockReccomendation2.update());
  });
}