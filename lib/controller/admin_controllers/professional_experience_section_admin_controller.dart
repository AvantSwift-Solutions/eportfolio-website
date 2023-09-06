import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/ProfessionalExperience.dart';
import '../../reposervice/professional_experience_repo_services.dart';

class ProfessionalExperienceSectionAdminController {
  final ProfessionalExperienceRepoService professionalExperienceRepoService;

  ProfessionalExperienceSectionAdminController(this.professionalExperienceRepoService); // Constructor

  Future<List<ProfessionalExperience>?>? getProfessionalExperienceSectionData() async {
    try {
      List<ProfessionalExperience>? allProfessionalExperiences = await professionalExperienceRepoService.getAllProfessionalExperiences();
      return allProfessionalExperiences;
    } catch (e) {
      return null;
    }
  }

  Future<bool>? updateProfessionalExperienceSectionData(int index, ProfessionalExperience newProfessionalExperience) async {
    try {
      List<ProfessionalExperience>? allProfessionalExperiences = await professionalExperienceRepoService.getAllProfessionalExperiences();

      if (allProfessionalExperiences!.isNotEmpty) {
        allProfessionalExperiences[index].jobTitle = newProfessionalExperience.jobTitle;
        allProfessionalExperiences[index].companyName = newProfessionalExperience.companyName;
        allProfessionalExperiences[index].logoURL = newProfessionalExperience.logoURL;
        allProfessionalExperiences[index].location = newProfessionalExperience.location;
        allProfessionalExperiences[index].startDate = newProfessionalExperience.startDate;
        allProfessionalExperiences[index].endDate = newProfessionalExperience.endDate;
        allProfessionalExperiences[index].description = newProfessionalExperience.description;
        
        bool updateSuccess = await allProfessionalExperiences[index].update();
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