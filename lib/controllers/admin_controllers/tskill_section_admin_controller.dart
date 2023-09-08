import 'dart:typed_data';

import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/TSkill.dart';

class TSkillSectionAdminController {
  final TSkillRepoService tSkillRepoService;

  TSkillSectionAdminController(this.tSkillRepoService); // Constructor

  Future<List<TSkill>?>? getTSkillSectionData() async {
    try {
      List<TSkill>? allTSkill = await tSkillRepoService.getAllTSkill();
      return allTSkill;
    } catch (e) {
      return null;
    }
  }

  Future<bool>? updateTSkillSectionData(int index, TSkill newTSkill) async {
    try {
      List<TSkill>? allTSkill = await tSkillRepoService.getAllTSkill();

      if (allTSkill!.isNotEmpty) {
        allTSkill[index].name = newTSkill.name;
        allTSkill[index].imageURL = newTSkill.imageURL;       
        bool updateSuccess = await allTSkill[index].update() ?? false;
        return updateSuccess;
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