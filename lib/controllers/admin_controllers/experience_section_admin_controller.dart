import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/Experience.dart';
import '../../reposervice/experience_repo_services.dart';

class ExperienceSectionAdminController {
  final ExperienceRepoService experienceRepoService;

  ExperienceSectionAdminController(this.experienceRepoService); // Constructor

  Future<List<Experience>?>? getSectionData() async {
    try {
      List<Experience>? allExperiences =
          await experienceRepoService.getAllExperiences();
      return allExperiences;
    } catch (e) {
      log('Error getting Experience list: $e');
      return null;
    }
  }

  Future<bool>? updateSectionData(
      int index, Experience newExperience) async {
    try {
      List<Experience>? allExperiences =
          await experienceRepoService.getAllExperiences();

      if (allExperiences!.isNotEmpty) {
        allExperiences[index].jobTitle = newExperience.jobTitle;
        allExperiences[index].companyName = newExperience.companyName;
        allExperiences[index].logoURL = newExperience.logoURL;
        allExperiences[index].location = newExperience.location;
        allExperiences[index].startDate = newExperience.startDate;
        allExperiences[index].endDate = newExperience.endDate;
        allExperiences[index].description = newExperience.description;

        bool updateSuccess = await allExperiences[index].update() ?? false;
        return updateSuccess; // Return true if update is successful
      } else {
        return false;
      }
    } catch (e) {
      log('Error updating Experience: $e');
      return false;
    }
  }

  // Future<bool> deleteData(List<Experience> list, int index) async {

  //   for (var i = index + 1; i < list.length; i++) {
  //     list[i].index = list[i].index! - 1;
  //     await list[i].update();
  //   }

  //   try {
  //     await list[index].delete();
  //     return true;
  //   } catch (e) {
  //     log('Error deleting: $e');
  //     return false;
  //   }
    
  // }

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
