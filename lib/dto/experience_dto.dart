import 'package:cloud_firestore/cloud_firestore.dart';

class ExperienceDTO {
  String? jobTitle;
  String? companyName;
  String? location;
  Timestamp? startDate;
  Timestamp? endDate;
  String? description;
  String? logoURL;

  ExperienceDTO(
      {required this.jobTitle,
      required this.companyName,
      required this.location,
      required this.startDate,
      required this.endDate,
      required this.description,
      required this.logoURL});
}
