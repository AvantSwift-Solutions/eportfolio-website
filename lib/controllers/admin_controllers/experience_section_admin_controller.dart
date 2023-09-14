import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tuple/tuple.dart';
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

  String getSectionName() {
    return 'Interpersonal Skill';
  }

  Future<List<Tuple2<int, String>>> getSectionTitles() async {
    List<Experience>? exps = await getSectionData();
    var ret = <Tuple2<int, String>>[];
    if (exps != null) {
      for (var i = 0; i < exps.length; i++) {
        ret.add(Tuple2(exps[i].index!, '${exps[i].jobTitle} at ${exps[i].companyName}'));
      }
    }
    return ret;
  }

  Future<void> updateSectionOrder(List<Tuple2<int, String>> items) async {
    List<Experience>? exps = await getSectionData();
    if (exps == null) return;
    for (var i = 0; i < items.length; i++) {
      var skill = exps[items[i].item1];
      skill.index = i;
      await skill.update();
    }
  }

  Future<bool> deleteData(List<Experience> list, int index) async {

    for (var i = index + 1; i < list.length; i++) {
      list[i].index = list[i].index! - 1;
      await list[i].update();
    }

    try {
      await list[index].delete();
      return true;
    } catch (e) {
      log('Error deleting: $e');
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
