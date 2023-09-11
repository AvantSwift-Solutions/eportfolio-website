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
    List<ISkill>? skills = await getSectionData();
    var ret = <Tuple2<int, String>>[];
    if (skills != null) {
      for (var i = 0; i < skills.length; i++) {
        ret.add(Tuple2(skills[i].index!, skills[i].name!));
      }
    }
    return ret;
  }

  Future<void> updateSectionOrder(List<Tuple2<int, String>> items) async {
    List<ISkill>? skills = await getSectionData();
    if (skills == null) return;
    for (var i = 0; i < items.length; i++) {
      var skill = skills[items[i].item1];
      skill.index = i;
      await skill.update();
    }
  }

}
