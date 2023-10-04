// ignore_for_file: constant_identifier_names

enum Sections {
  Experience,
  Projects,
  AwardsCerts,
  Contact,
  ISkill,
  TSkill,
  Education,
  Recommendation,
  AboutMe,
  Default,
}

class SectionResultDTO {
  late final Sections section;
  final String sectionName;

  SectionResultDTO({
    required this.section,
    required this.sectionName,
  });

  static Sections toSectionsEnumFromString(String sectionName) {
    switch (sectionName) {
      case 'Experience':
        return Sections.Experience;
      case 'ISkill':
        return Sections.ISkill;
      case 'Project':
        return Sections.Projects;
      case 'AwardCert':
        return Sections.AwardsCerts;
      case 'Contact':
        return Sections.Contact;
      case 'Education':
        return Sections.Education;
      case 'Recommendation':
        return Sections.Recommendation;
      case 'TSKill':
        return Sections.TSkill;
      case 'User':
        return Sections.AboutMe;
      default:
        return Sections.Default;
    }
  }

  static String stringFromEnum(Sections section) {
    switch (section) {
      case Sections.Experience:
        return 'Experience: ';
      case Sections.ISkill:
        return 'Interpersonal Skills: ';
      case Sections.Projects:
        return 'Projects: ';
      case Sections.AwardsCerts:
        return 'Awards & Certifications: ';
      case Sections.Contact:
        return 'Contact: ';
      case Sections.Education:
        return 'Education: ';
      case Sections.Recommendation:
        return 'Peer Recommendations: ';
      case Sections.TSkill:
        return 'Technical Skills: ';
      case Sections.AboutMe:
        return 'About Me: ';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'section: $section sectionName: $sectionName';
  }
}
