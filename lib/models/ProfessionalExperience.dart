import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionalExperience {
  final String professionalExperienceId;
  String jobTitle;
  String? companyName;
  String? location;
  DateTime? startDate;
  DateTime? endDate;
  String? description;
  String? logoUrl;  
  Timestamp? creationTimestamp;

  ProfessionalExperience({
    required this.professionalExperienceId,
    required this.jobTitle,
    required this.companyName,
    this.logoUrl,
    this.location,
    this.startDate,
    this.endDate,
    this.description,
    required this.creationTimestamp,
  });

  factory ProfessionalExperience.fromDocumentSnapshot(DocumentSnapshot snapshot) {
  try {
    final data = snapshot.data() as Map<String, dynamic>;

    final professionalExperienceId = data['professionalExperienceId'] as String;
    final jobTitle = data['jobTitle'] as String;
    final companyName = data['companyName'] as String;
    final creationTimestamp = data['creationTimestamp'] as Timestamp;
    final location = data['location'] as String?;
    final description = data['description'] as String?;
    final startDateTimestamp = data['startDate'] as Timestamp?;
    final endDateTimestamp = data['endDate'] as Timestamp?;
    final logoUrl = data['logoUrl'] as String?;

    DateTime? startDate;
    DateTime? endDate;

    if (startDateTimestamp != null) {
      startDate = startDateTimestamp.toDate();
    }

    if (endDateTimestamp != null) {
      endDate = endDateTimestamp.toDate();
    }

    return ProfessionalExperience(
      creationTimestamp: creationTimestamp,
      professionalExperienceId: professionalExperienceId,
      jobTitle: jobTitle,
      companyName: companyName,
      location: location,
      description: description,
      startDate: startDate,
      endDate: endDate,
      logoUrl: logoUrl,
    );
  } catch (e) {
    rethrow;
  }
}

  Map<String, dynamic> toMap() {
    return {
      'creationTimestamp': creationTimestamp,
      'professionalExperienceId': professionalExperienceId,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'location': location,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'logoUrl': logoUrl,
    };
  }

  Future<void> create() async {
    try {
      await FirebaseFirestore.instance.collection('professional_experience').doc(professionalExperienceId).set(toMap());
      print('Professional experience document created');
    } catch (e) {
      print('Error creating Professional experience document: $e');
    }
  }

  Future<bool> update() async {
    try {
      await FirebaseFirestore.instance
          .collection('professional_experience')
          .doc(professionalExperienceId)
          .update(toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('professional_experience').doc(professionalExperienceId).delete();
      print('User document deleted');
    } catch (e) {
      print('Error deleting user document: $e');
    }
  }

}
