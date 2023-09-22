import 'package:avantswift_portfolio/controllers/view_controllers/recommendation_section_controller.dart';
import 'package:avantswift_portfolio/models/Recommendation.dart';
import 'package:avantswift_portfolio/reposervice/recommendation_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/recommendation_section_controller_test.mocks.dart';


@GenerateMocks([RecommendationRepoService, Recommendation])
void main() {
  group('RecommendationController Tests', () {
    late RecommendationSectionController controller;
    late MockRecommendationRepoService mockRepoService;
    late MockRecommendation mockRecommendation1;
    late MockRecommendation mockRecommendation2;

    setUp(() {
      mockRecommendation1 = MockRecommendation();
      when(mockRecommendation1.rid).thenReturn('mockId1');
      when(mockRecommendation1.colleagueName).thenReturn('Mock Name 1');
      when(mockRecommendation1.colleagueJobTitle).thenReturn('Mock Job Title 1');
      when(mockRecommendation1.description).thenReturn('Mock Description 1');
      when(mockRecommendation1.imageURL).thenReturn('http://example.com/image1.png');

      mockRecommendation2 = MockRecommendation();
      when(mockRecommendation2.rid).thenReturn('mockId2');
      when(mockRecommendation2.colleagueName).thenReturn('Mock Name 2');
      when(mockRecommendation2.colleagueJobTitle).thenReturn('Mock Job Title 2');
      when(mockRecommendation2.description).thenReturn('Mock Description 2');
      when(mockRecommendation2.imageURL).thenReturn('http://example.com/image2.png');

      mockRepoService = MockRecommendationRepoService();
      controller = RecommendationSectionController(mockRepoService);
    });

    test('getAllRecommendations returns a list of recommendations', () async {
      // ignore: non_constant_identifier_names
      final recommendations = [
        Recommendation(
          rid: 'mockId1',
          colleagueName: 'Mock Name 1',
          colleagueJobTitle: 'Mock Job Title 1',
          description: 'Mock Description 1',
          imageURL: 'http://example.com/image1.png',
        ),
        Recommendation(
          rid: 'mockId2',
          colleagueName: 'Mock Name 2',
          colleagueJobTitle: 'Mock Job Title 2',
          description: 'Mock Description 2',
          imageURL: 'http://example.com/image2.png',
        ),
      ];

      when(mockRepoService.getAllRecommendations())
          .thenAnswer((_) async => recommendations);

      final recommendationList = await controller.getRecommendationSectionData();

      expect(recommendationList!.length, 2);

      var recommendation1 = recommendationList[0];
      var recommendation2 = recommendationList[1];

      expect(recommendation1.colleagueName, mockRecommendation1.colleagueName);
      expect(recommendation1.colleagueJobTitle, mockRecommendation1.colleagueJobTitle);
      expect(recommendation1.description, mockRecommendation1.description);
      expect(recommendation1.imageURL, mockRecommendation1.imageURL);

      expect(recommendation2.colleagueName, mockRecommendation2.colleagueName);
      expect(recommendation2.colleagueJobTitle, mockRecommendation2.colleagueJobTitle);
      expect(recommendation2.description, mockRecommendation2.description);
      expect(recommendation2.imageURL, mockRecommendation2.imageURL);

      verify(mockRepoService.getAllRecommendations());
    });

    test('getAllRecommendations returns null on error', () async {
      when(mockRepoService.getAllRecommendations())
          .thenThrow(Exception('Test Exception'));

      final projects = await controller.getRecommendationSectionData();
      expect(projects, null);
    });
  });
}