class ExperienceDTO {
  String? jobTitle;
  String? companyName;
  String? location;
  String? startDate;
  String? endDate;
  String? description;
  String? logoURL;
  int? index;
  String? employmentType;

  ExperienceDTO(
      {required this.jobTitle,
      required this.companyName,
      this.location,
      this.startDate,
      this.endDate,
      this.description,
      this.logoURL,
      this.index,
      this.employmentType});
}
