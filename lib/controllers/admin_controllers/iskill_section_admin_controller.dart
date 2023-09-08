import 'dart:developer';
import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart';
import '../../models/ISkill.dart';

class ISkillSectionAdminController {
  final ISkillRepoService iSkillRepoService;

  ISkillSectionAdminController(this.iSkillRepoService); // Constructor

  Future<List<ISkill>?>? getISkillSectionData() async {
    try {
      List<ISkill>? allISkill = await iSkillRepoService.getAllISkill();
      return allISkill;
    } catch (e) {
      log('Error getting ISkill list: $e');
      return null;
    }
  }

  Future<bool>? updateISkillSectionData(int index, ISkill newISkill) async {
    try {
      List<ISkill>? allISkill = await iSkillRepoService.getAllISkill();

      if (allISkill!.isNotEmpty) {
        allISkill[index].name = newISkill.name;       
        bool updateSuccess = await allISkill[index].update() ?? false;
        return updateSuccess;
      } else {
        return false;
      }
    } catch (e) {
      log('Error updating ISkill: $e');
      return false;
    }
  }

}