import 'dart:developer';
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
    return 'Professional Experiences';
  }

  Future<List<Tuple2<int, String>>> getSectionTitles() async {
    List<Experience>? list = await getSectionData();
    var ret = <Tuple2<int, String>>[];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        ret.add(Tuple2(
            list[i].index!, '${list[i].jobTitle} at ${list[i].companyName}'));
      }
    }
    return ret;
  }

  Future<void> updateSectionOrder(List<Tuple2<int, String>> items) async {
    List<Experience>? list = await getSectionData();
    if (list == null) return;
    for (var i = 0; i < items.length; i++) {
      var x = list[items[i].item1];
      x.index = i;
      await x.update();
    }
  }

  String defaultOrderName() {
    // Button will say 'Order _'
    return 'by End Date';
  }

  Future<void> applyDefaultOrder() async {
    List<Experience>? list = await getSectionData();
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
}
