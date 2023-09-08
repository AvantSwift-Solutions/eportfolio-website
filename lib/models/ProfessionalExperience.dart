import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProfessionalExperience {
  final String? peid;
  String? jobTitle;
  String? companyName;
  String? location;
  Timestamp? startDate;
  Timestamp? endDate;
  String? description;
  String? logoURL; 

  ProfessionalExperience({
    required this.peid,
    required this.jobTitle,
    required this.companyName,
    this.location,
    this.startDate,
    this.endDate,
    this.description,
    this.logoURL,
  });

  factory ProfessionalExperience.fromDocumentSnapshot(DocumentSnapshot snapshot) {
  try {
    final data = snapshot.data() as Map<String, dynamic>;
    final jobTitle = data['jobTitle'];
    final companyName = data['companyName'];
    final location = data['location'];
    final description = data['description'];
    final startDate = data['startDate'];
    final endDate = data['endDate'];
    final logoURL = data['logoURL'];

    return ProfessionalExperience(
      peid: snapshot.id,
      jobTitle: jobTitle,
      companyName: companyName,
      location: location,
      description: description,
      startDate: startDate,
      endDate: endDate,
      logoURL: logoURL,
    );
  } catch (e) {
    rethrow;
  }
}

  Map<String, dynamic> toMap() {
    return {
      'peid': peid,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'location': location,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'logoURL': logoURL,
    };
  }

  Future<void> create() async {
    try {
      final id = const Uuid().v4();
      await FirebaseFirestore.instance.collection('ProfessionalExperience').doc(id).set(toMap());
      print('Professional experience document created');
    } catch (e) {
      print('Error creating Professional experience document: $e');
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('ProfessionalExperience')
          .doc(peid)
          .update(toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('ProfessionalExperience').doc(peid).delete();
      print('User document deleted');
    } catch (e) {
      print('Error deleting user document: $e');
    }
  }

}
