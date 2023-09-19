import 'dart:developer';
import 'dart:typed_data';

import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tuple/tuple.dart';

import '../../models/TSkill.dart';

class TSkillSectionAdminController {
  final TSkillRepoService tSkillRepoService;

  TSkillSectionAdminController(this.tSkillRepoService); // Constructor

  Future<List<TSkill>?>? getSectionData() async {
    try {
      List<TSkill>? allTSkill = await tSkillRepoService.getAllTSkill();
      return allTSkill;
    } catch (e) {
      log('Error getting TSkill list: $e');
      return null;
    }
  }

  String getSectionName() {
    return 'Technical Skills';
  }

  Future<List<Tuple2<int, String>>> getSectionTitles() async {
    List<TSkill>? list = await getSectionData();
    var ret = <Tuple2<int, String>>[];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        ret.add(Tuple2(list[i].index!, list[i].name!));
      }
    }
    return ret;
  }

  Future<void> updateSectionOrder(List<Tuple2<int, String>> items) async {
    List<TSkill>? list = await getSectionData();
    if (list == null) return;
    for (var i = 0; i < items.length; i++) {
      var x = list[items[i].item1];
      x.index = i;
      await x.update();
    }
  }

  String defaultOrderName() {
    // Button will say 'Order _'
    return 'Alphabetically';
  }

  Future<void> applyDefaultOrder() async {
    List<TSkill>? list = await getSectionData();
    if (list == null) return;

    list.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

    for (var i = 0; i < list.length; i++) {
      list[i].index = i;
      await list[i].update();
    }
  }

  Future<bool> deleteData(List<TSkill> list, int index) async {
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
