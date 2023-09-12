import 'dart:developer';

import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';

import '../../dto/experience_dto.dart';
import '../../models/Experience.dart';

class ExperiencePageController {
  final ExperienceRepoService experienceRepoService;

  ExperiencePageController(this.experienceRepoService); // Constructor

  Future<List<ExperienceDTO>?>? getExperiencePageData() async {
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
}
