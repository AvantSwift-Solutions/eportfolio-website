import 'dart:developer';
import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart';
import 'package:tuple/tuple.dart';
import '../../models/ISkill.dart';

class ISkillSectionAdminController {
  final ISkillRepoService iSkillRepoService;

  ISkillSectionAdminController(this.iSkillRepoService); // Constructor

  Future<List<ISkill>?>? getSectionData() async {
    try {
      List<ISkill>? allISkill = await iSkillRepoService.getAllISkill();
      return allISkill;
    } catch (e) {
      log('Error getting ISkill list: $e');
      return null;
    }
  }

  String getSectionName() {
    return 'Interpersonal Skill';
  }

  Future<List<Tuple2<int, String>>> getSectionTitles() async {
    List<ISkill>? list = await getSectionData();
    var ret = <Tuple2<int, String>>[];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        ret.add(Tuple2(list[i].index!, list[i].name!));
      }
    }
    return ret;
  }

  Future<void> updateSectionOrder(List<Tuple2<int, String>> items) async {
    List<ISkill>? list = await getSectionData();
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
    List<ISkill>? list = await getSectionData();
    if (list == null) return;

    list.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

    for (var i = 0; i < list.length; i++) {
      list[i].index = i;
      await list[i].update();
    }
  }

  Future<bool> deleteData(List<ISkill> list, int index) async {
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
