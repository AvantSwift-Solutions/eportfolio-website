import 'dart:developer';

import 'package:avantswift_portfolio/models/Education.dart';

import '../../dto/education_section_dto.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../reposervice/education_repo_services.dart';

class EducationSectionController {
  final EducationRepoService educationRepoService;

  EducationSectionController(this.educationRepoService); // Constructor

  // Function to format Timestamp to "Month Year" format
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return "Null Timestamp";
    }
    final DateTime dateTime = (timestamp as Timestamp).toDate();
    final String formattedDate = DateFormat.yMMM().format(dateTime);
    return formattedDate;
  }

  String formatEndDateTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return "Present";
    }

    return formatTimestamp(timestamp);
  }

  Future<List<EducationDTO>?>? getEducationSectionData() async {
    try {
      List<Education>? educationList =
          await educationRepoService.getAllEducation();
      if (educationList != null) {
        return educationList.map((education) {
          return EducationDTO(
            startDate: formatTimestamp(education.startDate),
            endDate: formatEndDateTimestamp(education.endDate),
            description: education.description,
            logoURL: education.logoURL,
            index: education.index,
            schoolName: education.schoolName,
            degree: education.degree,
            major: education.major,
            gradeDescription: education.gradeDescription,
            grade: education.grade,
          );
        }).toList();
      } else {
        return [
          EducationDTO(
            startDate: 'unknown',
            endDate: 'unknown',
            description: 'unknown',
            logoURL: 'unknown',
            index: -1,
            schoolName: 'unknown',
            degree: 'unknown',
            major: 'unknown',
            gradeDescription: 'unknown',
            grade: -1,
          )
        ];
      }
    } catch (e) {
      log('Error getting education section data: $e');
      return [
        EducationDTO(
          startDate: 'Error',
          endDate: 'Error',
          description: 'Error',
          logoURL: 'Error',
          index: -2,
          schoolName: 'Error',
          degree: 'Error',
          major: 'Error',
          gradeDescription: 'Error',
          grade: -2,
        )
      ];
    }
  }
}
