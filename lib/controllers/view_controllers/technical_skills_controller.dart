import 'dart:developer';

import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:flutter/material.dart';
import '../../models/TSkill.dart';

class TechnicalSkillsController {
  final TSkillRepoService tSkillRepoService;

  TechnicalSkillsController(this.tSkillRepoService); // Constructor

  Future<List<String>?>? getTechnicalSkillsName() async {
    try {
      List<TSkill>? allTSkill = await tSkillRepoService.getAllTSkill();
      List<String> allTSkillNames = [];
      for (TSkill tSkill in allTSkill!) {
        allTSkillNames.add(tSkill.name!);
      }
      return allTSkillNames;
    } catch (e) {
      log('Error getting ISkill list: $e');
      return null;
    }
  }

  Future<List<Image>> getTechnicalSkillImages() async {
    try {
      List<TSkill>? allTSkill = await tSkillRepoService.getAllTSkill();
      List<Image> allTSkillImages = [];
      for (TSkill tSkill in allTSkill!) {
        // Load the image from the network or assets
        allTSkillImages.add(
          Image.network(
            tSkill.imageURL!,
          ),
        );
      }

      List<Image> curPageImages = allTSkillImages;
      return curPageImages;
    } catch (e) {
      log('Error getting ISkill list: $e');
      rethrow; // Rethrow the exception to handle it in your UI.
    }
  }

  Future<Image> getCentralImage() async {
    return Image.asset('logo.png', fit: BoxFit.contain);
  }
}
