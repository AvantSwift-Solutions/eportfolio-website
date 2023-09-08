import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../models/Education.dart';
import '../../reposervice/education_repo_services.dart'; // Import the Education class

class EducationSectionAdminController {
  final EducationRepoService educationRepoService;

  EducationSectionAdminController(this.educationRepoService); // Constructor

  Future<List<Education>?>? getEducationSectionData() async {
    try {
      List<Education>? allEducation =
          await educationRepoService.getAllEducation();
      return allEducation;
    } catch (e) {
      log('Error getting Education list: $e');
      return null;
    }
  }

  Future<bool>? updateEducationSectionData(
      int index, Education newEducation) async {
    try {
      List<Education>? allEducation =
          await educationRepoService.getAllEducation();

      if (allEducation!.isNotEmpty) {
        allEducation[index].startDate = newEducation.startDate;
        allEducation[index].endDate = newEducation.endDate;
        allEducation[index].logoURL = newEducation.logoURL;
        allEducation[index].schoolName = newEducation.schoolName;
        allEducation[index].degree = newEducation.degree;
        allEducation[index].description = newEducation.description;

        bool updateSuccess = await allEducation[index].update() ?? false;
        return updateSuccess;
      } else {
        return false;
      }
    } catch (e) {
      log('Error updating Education: $e');
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
