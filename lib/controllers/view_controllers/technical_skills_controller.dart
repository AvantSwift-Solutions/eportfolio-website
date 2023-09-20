import 'dart:developer';

import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../models/TSkill.dart';

class TechnicalSkillsController {
  final TSkillRepoService tSkillRepoService;

  TechnicalSkillsController(this.tSkillRepoService); // Constructor

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
    try {
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child('images/technical_skills_image');
      final url = await ref.getDownloadURL();
      return Image.network(url, fit: BoxFit.contain);
    } catch (e) {
      log('Error getting central image: $e');
      rethrow;
    }
  }
}
