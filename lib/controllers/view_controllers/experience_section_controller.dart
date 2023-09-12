import 'dart:developer';

import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';

import '../../dto/experience_dto.dart';
import '../../models/Experience.dart';

class ExperienceSectionController {
  final ExperienceRepoService experienceRepoService;

  ExperienceSectionController(this.experienceRepoService); // Constructor

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
            startDate: experience.startDate,
            endDate: experience.endDate,
            description: experience.description,
            logoURL: experience.logoURL,
          );
        }).toList();
      } else {
        return [
          ExperienceDTO(
            jobTitle: 'unknown',
            companyName: 'unknown',
            location: 'unknown',
            startDate: null, // or Timestamp.fromDate(DateTime(2000, 1, 1))
            endDate: null, // or Timestamp.fromDate(DateTime(2000, 1, 1))
            description: 'unknown',
            logoURL: 'unknown',
          )
        ];
      }
    } catch (e) {
      log('Error getting contact section data: $e');
      return [
        ExperienceDTO(
          jobTitle: 'Error',
          companyName: 'Error',
          location: 'Error',
          startDate: null,
          endDate: null,
          description: 'Error',
          logoURL: 'Error',
        )
      ];
    }
  }

  Future<ExperienceDTO?> getExperienceData(int experienceIndex) async {
    try {
      List<Experience>? experiences =
          await experienceRepoService.getAllExperiences();

      if (experiences != null &&
          experienceIndex >= 0 &&
          experienceIndex < experiences.length) {
        final experience = experiences[experienceIndex];

        return ExperienceDTO(
          jobTitle: experience.jobTitle,
          companyName: experience.companyName,
          location: experience.location,
          startDate: experience.startDate,
          endDate: experience.endDate,
          description: experience.description,
          logoURL: experience.logoURL,
        );
      } else {
        return null; // Return null if the index is out of bounds or experiences is null
      }
    } catch (e) {
      log('Error getting experience by index: $e');
      return null; // Return null in case of an error
    }
  }
}
