import 'package:avantswift_portfolio/models/Recommendation.dart';
import 'package:avantswift_portfolio/reposervice/recommendation_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/recommendation_section_admin_controller.dart';
import 'mocks/recommendation_section_admin_controller_test.mocks.dart';

@GenerateMocks([RecommendationRepoService])
class MockRecommendation extends Mock implements Recommendation {}

void main() {
  late MockRecommendation mockRecommendation1;
  late MockRecommendation mockRecommendation2;

  late RecommendationSectionAdminController controller;
  late RecommendationRepoService mockRepoService;

  setUp(() {
    mockRecommendation1 = MockRecommendation();
    when(mockRecommendation1.rid).thenReturn('mockrid1');
    when(mockRecommendation1.colleagueName).thenReturn('Mock Name1');
    when(mockRecommendation1.colleagueJobTitle).thenReturn('Mock Job Title1');
    when(mockRecommendation1.description).thenReturn('Mock Location1');
    when(mockRecommendation1.imageURL)
        .thenReturn('http://example.com/mock_image1.jpg');

    mockRecommendation2 = MockRecommendation();
    when(mockRecommendation2.rid).thenReturn('mockrid2');
    when(mockRecommendation2.colleagueName).thenReturn('Mock Name2');
    when(mockRecommendation2.colleagueJobTitle).thenReturn('Mock Job Title2');
    when(mockRecommendation2.description).thenReturn('Mock Location1');
    when(mockRecommendation2.imageURL)
        .thenReturn('http://example.com/mock_image1.jpg');

    mockRepoService = MockRecommendationRepoService();
    controller = RecommendationSectionAdminController(mockRepoService);
  });

  group('Recommendation section admin controller tests', () {
    test(
        'getRecommendationSectionData returns correct data when recommendation is not null',
        () async {
      when(mockRepoService.getAllRecommendations())
          .thenAnswer((_) async => [mockRecommendation1, mockRecommendation2]);
      final getAllRecommendations =
          await controller.getRecommendationSectionData();

      // Make assertions on the returned data
      expect(getAllRecommendations!.length, 2);

      var rec1 = getAllRecommendations[0];
      var rec2 = getAllRecommendations[1];

      expect(rec1.rid, mockRecommendation1.rid);
      expect(rec1.colleagueName, mockRecommendation1.colleagueName);
      expect(rec1.colleagueJobTitle, mockRecommendation1.colleagueJobTitle);
      expect(rec1.description, mockRecommendation1.description);
      expect(rec1.imageURL, mockRecommendation1.imageURL);

      expect(rec2.rid, mockRecommendation2.rid);
      expect(rec2.colleagueName, mockRecommendation2.colleagueName);
      expect(rec2.colleagueJobTitle, mockRecommendation2.colleagueJobTitle);
      expect(rec2.description, mockRecommendation2.description);
      expect(rec2.imageURL, mockRecommendation2.imageURL);
    });

    test(
        'getRecommendationSectionData returns null data when recommendation is null',
        () async {
      when(mockRepoService.getAllRecommendations())
          .thenAnswer((_) async => null);
      final recommendationSectionData =
          await controller.getRecommendationSectionData();
      expect(recommendationSectionData, null);
    });

    test('getRecommendationSectionData returns null data on exception',
        () async {
      when(mockRepoService.getAllRecommendations())
          .thenThrow(Exception('Test Exception'));
      final recommendationSectionData =
          await controller.getRecommendationSectionData();
      expect(recommendationSectionData, null);
    });

    test('updateRecommendationSectionData returns true on successful update',
        () async {
      when(mockRepoService.getAllRecommendations())
          .thenAnswer((_) async => [mockRecommendation1, mockRecommendation2]);
      when(mockRecommendation1.update()).thenAnswer((_) async => true);

      final updateResult = await controller.updateRecommendationSectionData(
        0,
        Recommendation(
          rid: 'rid1',
          colleagueName: 'New Mock Name1',
          colleagueJobTitle: 'New Mock Job Title1',
          description: 'New Mock Description1',
          imageURL: 'http://example.com/new_mock_image1.jpg',
        ),
      );

      expect(updateResult, true);
      verify(mockRecommendation1.colleagueName = 'New Mock Name1');
      verify(mockRecommendation1.colleagueJobTitle = 'New Mock Job Title1');
      verify(mockRecommendation1.description = 'New Mock Description1');
      verify(mockRecommendation1.imageURL =
          'http://example.com/new_mock_image1.jpg');

      verify(mockRecommendation1.update()); // Verify that the method was called
    });

    test('updateRecommendationSectionData returns false when user is null',
        () async {
      when(mockRepoService.getAllRecommendations())
          .thenAnswer((_) async => null);

      final updateResult = await controller.updateRecommendationSectionData(
        0,
        Recommendation(
          rid: 'rid1',
          colleagueName: 'New Mock Name1',
          colleagueJobTitle: 'New Mock Job Title1',
          description: 'New Mock Description1',
          imageURL: 'http://example.com/new_mock_image1.jpg',
        ),
      );

      expect(updateResult, false);

      verifyNever(mockRecommendation1.update());
      verifyNever(mockRecommendation2.update());
    });
  });
}
