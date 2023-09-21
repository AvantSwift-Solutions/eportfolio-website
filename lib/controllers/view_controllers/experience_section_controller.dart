import 'dart:developer';

import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';

import '../../dto/experience_dto.dart';
import '../../models/Experience.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExperienceSectionController {
  final ExperienceRepoService experienceRepoService;

  ExperienceSectionController(this.experienceRepoService); // Constructor

  // Function to format Timestamp to "Month Year" format
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return "Null Timestamp";
    }
    final DateTime dateTime = timestamp.toDate();
    final String formattedDate = DateFormat.yMMM().format(dateTime);
    return formattedDate;
  }

  String formatEndDateTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return "Present";
    }

    return formatTimestamp(timestamp);
  }

  Future<List<ExperienceDTO>?>? getExperienceSectionData() async {
    try {
      List<Experience>? experiences =
          await experienceRepoService.getAllExperiences();
      if (experiences != null) {
        return experiences.map((experience) {
          return ExperienceDTO(
            jobTitle: experience.jobTitle,
            companyName: experience.companyName,
            location: experience.location,
            startDate: formatTimestamp(experience.startDate),
            endDate: formatEndDateTimestamp(experience.endDate),
            description: experience.description,
            logoURL: experience.logoURL,
            index: experience.index,
            employmentType: experience.employmentType,
          );
        }).toList();
      } else {
        return [
          ExperienceDTO(
            jobTitle: 'unknown',
            companyName: 'unknown',
            location: 'unknown',
            startDate: 'unknown',
            endDate: 'unknown',
            description: 'unknown',
            logoURL: 'unknown',
            index: -1,
            employmentType: 'unknown',
          )
        ];
      }
    } catch (e) {
      log('Error getting experience section data: $e');
      return [
        ExperienceDTO(
          jobTitle: 'Error',
          companyName: 'Error',
          location: 'Error',
          startDate: 'Error',
          endDate: 'Error',
          description: 'Error',
          logoURL: 'Error',
          index: -2,
          employmentType: 'Error',
        )
      ];
    }
  }
}