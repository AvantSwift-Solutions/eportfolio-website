import 'dart:developer';
import '../../models/Recommendation.dart';
import '../../reposervice/recommendation_repo_services.dart';

class RecommendationSectionController {
  final RecommendationRepoService recommendationRepoService;

  RecommendationSectionController(
      this.recommendationRepoService); // Constructor

  Future<List<Recommendation>?>? getRecommendationSectionData() async {
    try {
      List<Recommendation>? allRecommendations =
          await recommendationRepoService.getAllRecommendations();
      return allRecommendations;
    } catch (e) {
      log('Error getting Recommendation list: $e');
      return null;
    }
  }
}
