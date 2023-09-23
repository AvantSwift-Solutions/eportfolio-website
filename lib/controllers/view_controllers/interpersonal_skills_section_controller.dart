import 'dart:developer';

import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart';

import '../../models/ISkill.dart';

class InterpersonalSkillsController {
  final ISkillRepoService iSkillRepoService;

  InterpersonalSkillsController(this.iSkillRepoService); // Constructor

  Future<List<String>?>? getIPersonalSkills() async {
    try {
      List<ISkill>? allISkill = await iSkillRepoService.getAllISkill();
      List<String> allISkillNames = [];
      for (ISkill iSkill in allISkill!) {
        allISkillNames.add(iSkill.name!);
      }
      return allISkillNames;
    } catch (e) {
      log('Error getting ISkill list: $e');
      return null;
    }
  }
}
