import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/Reccomendation.dart';
import '../../reposervice/reccomendation_repo_services.dart';

class ReccomendationSectionAdminController {
  final ReccomendationRepoService reccomendationRepoService;

  ReccomendationSectionAdminController(this.reccomendationRepoService); // Constructor

  Future<List<Reccomendation>?>? getReccomendationSectionData() async {
    try {
      List<Reccomendation>? allReccomendations = await reccomendationRepoService.getAllReccomendations();
      return allReccomendations;
    } catch (e) {
      return null;
    }
  }

  Future<bool>? updateReccomendationSectionData(int index, Reccomendation newReccomendation) async {
    try {
      List<Reccomendation>? allReccomendations = await reccomendationRepoService.getAllReccomendations();

      if (allReccomendations!.isNotEmpty) {
        allReccomendations[index].colleagueName = newReccomendation.colleagueName;
        allReccomendations[index].colleagueJobTitle = newReccomendation.colleagueJobTitle;
        allReccomendations[index].description = newReccomendation.description;
        allReccomendations[index].imageURL = newReccomendation.imageURL;
        
        bool updateSuccess = await allReccomendations[index].update();
        return updateSuccess; // Return true if update is successful
      } else {
        return false;
      }
    } catch (e) {
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
      print('Error uploading image: $e');
      return null;
    }
  }

}
