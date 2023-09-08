import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/Recommendation.dart';
import '../../reposervice/recommendation_repo_services.dart';

class RecommendationSectionAdminController {
  final RecommendationRepoService recommendationRepoService;

  RecommendationSectionAdminController(
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

  Future<bool>? updateRecommendationSectionData(
      int index, Recommendation newRecommendation) async {
    try {
      List<Recommendation>? allRecommendations =
          await recommendationRepoService.getAllRecommendations();

      if (allRecommendations!.isNotEmpty) {
        allRecommendations[index].colleagueName =
            newRecommendation.colleagueName;
        allRecommendations[index].colleagueJobTitle =
            newRecommendation.colleagueJobTitle;
        allRecommendations[index].description = newRecommendation.description;
        allRecommendations[index].imageURL = newRecommendation.imageURL;

        bool updateSuccess = await allRecommendations[index].update() ?? false;
        return updateSuccess; // Return true if update is successful
      } else {
        return false;
      }
    } catch (e) {
      log('Error updating Recommendation: $e');
      return false;
    }
  }

  Future<String?> uploadImageAndGetURL(
      Uint8List imageBytes, String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final imageURL = await snapshot.ref.getDownloadURL();
      return imageURL;
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
