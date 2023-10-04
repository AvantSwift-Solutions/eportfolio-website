import 'package:flutter/material.dart';

class SectionKeysDTO {
  final GlobalKey experience;
  final GlobalKey skillsEdu;
  final GlobalKey projects;
  final GlobalKey awardsCerts;
  final GlobalKey contact;
  final GlobalKey aboutMe;

  SectionKeysDTO(
      {required this.experience,
      required this.skillsEdu,
      required this.projects,
      required this.awardsCerts,
      required this.contact,
      required this.aboutMe});
}
