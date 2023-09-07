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
    when(mockReccomendation1.rid).thenReturn('mockrid1');
    when(mockReccomendation1.colleagueName).thenReturn('Mock Name1');
    when(mockReccomendation1.colleagueJobTitle).thenReturn('Mock Job Title1');
    when(mockReccomendation1.description).thenReturn('Mock Location1');
    when(mockReccomendation1.imageURL).thenReturn('http://example.com/mock_image1.jpg');

    mockReccomendation2 = MockReccomendation();
    when(mockReccomendation2.rid).thenReturn('mockrid2');
    when(mockReccomendation2.colleagueName).thenReturn('Mock Name2');
    when(mockReccomendation2.colleagueJobTitle).thenReturn('Mock Job Title2');
    when(mockReccomendation2.description).thenReturn('Mock Location1');
    when(mockReccomendation2.imageURL).thenReturn('http://example.com/mock_image1.jpg');
    
    mockRepoService = MockReccomendationRepoService();
    controller = ReccomendationSectionAdminController(mockRepoService);
  });

  test('getReccomendationSectionData returns correct data when reccomendation is not null',
      () async {

    when(mockRepoService.getAllReccomendations()).thenAnswer((_) async
      => [mockReccomendation1, mockReccomendation2]);
    final getAllReccomendations = await controller.getReccomendationSectionData();

    // Make assertions on the returned data
    expect(getAllReccomendations!.length, 2);

    var rec1 = getAllReccomendations[0];
    var rec2 = getAllReccomendations[1];

    expect(rec1.rid, mockReccomendation1.rid);
    expect(rec1.colleagueName, mockReccomendation1.colleagueName);
    expect(rec1.colleagueJobTitle, mockReccomendation1.colleagueJobTitle);
    expect(rec1.description, mockReccomendation1.description);
    expect(rec1.imageURL, mockReccomendation1.imageURL);

    expect(rec2.rid, mockReccomendation2.rid);
    expect(rec2.colleagueName, mockReccomendation2.colleagueName);
    expect(rec2.colleagueJobTitle, mockReccomendation2.colleagueJobTitle);
    expect(rec2.description, mockReccomendation2.description);
    expect(rec2.imageURL, mockReccomendation2.imageURL);

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

  test('updateReccomendationSectionData returns true on successful update', () async {
    when(mockRepoService.getAllReccomendations()).thenAnswer((_) async
      => [mockReccomendation1, mockReccomendation2]);
    when(mockReccomendation1.update()).thenAnswer((_) async => true);

    final updateResult = await controller.updateReccomendationSectionData(0,
      Reccomendation(
        rid: 'rid1',
        colleagueName: 'New Mock Name1',
        colleagueJobTitle: 'New Mock Job Title1',
        description: 'New Mock Description1',
        imageURL: 'http://example.com/new_mock_image1.jpg',
      ),
    );

    expect(updateResult, true);
    verify(mockReccomendation1.colleagueName = 'New Mock Name1');
    verify(mockReccomendation1.colleagueJobTitle = 'New Mock Job Title1');
    verify(mockReccomendation1.description = 'New Mock Description1');
    verify(mockReccomendation1.imageURL = 'http://example.com/new_mock_image1.jpg');

    verify(mockReccomendation1.update()); // Verify that the method was called
  });

  test('updateReccomendationSectionData returns false when user is null', () async {
    when(mockRepoService.getAllReccomendations()).thenAnswer((_) async => null);

    final updateResult = await controller.updateReccomendationSectionData(0,
      Reccomendation(
        rid: 'rid1',
        colleagueName: 'New Mock Name1',
        colleagueJobTitle: 'New Mock Job Title1',
        description: 'New Mock Description1',
        imageURL: 'http://example.com/new_mock_image1.jpg',
      ),
    );

    expect(updateResult, false);

    verifyNever(mockReccomendation1.update());
    verifyNever(mockReccomendation2.update());
  });
}