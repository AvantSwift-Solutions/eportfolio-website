class EducationDTO {
  String? startDate;
  String? endDate;
  String? logoURL;
  String? schoolName;
  String? degree;
  String? description;
  String? gradeDescription;
  int? index;
  double? grade;
  String? major;

  EducationDTO({
    required this.startDate,
    required this.endDate,
    this.logoURL,
    required this.schoolName,
    required this.degree,
    this.description,
    this.gradeDescription,
    this.index,
    this.grade,
    this.major,
  });
}
