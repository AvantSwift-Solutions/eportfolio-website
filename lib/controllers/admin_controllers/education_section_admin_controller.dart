import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tuple/tuple.dart';
import '../../models/Education.dart';
import '../../reposervice/education_repo_services.dart';

class EducationSectionAdminController {
  final EducationRepoService educationRepoService;

  EducationSectionAdminController(this.educationRepoService); // Constructor

  Future<List<Education>?>? getSectionData() async {
    try {
      List<Education>? allEducations =
          await educationRepoService.getAllEducation();
      return allEducations;
    } catch (e) {
      log('Error getting Education list: $e');
      return null;
    }
  }

  String getSectionName() {
    return 'Professional Education';
  }

  Future<List<Tuple2<int, String>>> getSectionTitles() async {
    List<Education>? list = await getSectionData();
    var ret = <Tuple2<int, String>>[];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        ret.add(Tuple2(
            list[i].index!, '${list[i].degree} at ${list[i].schoolName}'));
      }
    }
    return ret;
  }

  Future<void> updateSectionOrder(List<Tuple2<int, String>> items) async {
    List<Education>? exps = await getSectionData();
    if (exps == null) return;
    for (var i = 0; i < items.length; i++) {
      var skill = exps[items[i].item1];
      skill.index = i;
      await skill.update();
    }
  }

  String defaultOrderName() {
    // Button will say 'Order _'
    return 'by End Date';
  }

  Future<void> applyDefaultOrder() async {
    List<Education>? list = await getSectionData();
    if (list == null) return;

    list.sort((a, b) {
      if (a.endDate == null && b.endDate == null) {
        return 0;
      } else if (a.endDate == null) {
        return -1;
      } else if (b.endDate == null) {
        return 1;
      } else {
        return b.endDate!.compareTo(a.endDate!);
      }
    });

    for (var i = 0; i < list.length; i++) {
      list[i].index = i;
      await list[i].update();
    }
  }

  Future<bool> deleteData(List<Education> list, int index) async {
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
