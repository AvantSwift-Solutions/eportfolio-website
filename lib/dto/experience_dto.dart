class ExperienceDTO {
  String? jobTitle;
  String? companyName;
  String? location;
  String? startDate;
  String? endDate;
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
