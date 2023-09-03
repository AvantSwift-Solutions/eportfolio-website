import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  Timestamp? startDate;
  Timestamp? endDate;
  String? logoURL;
  String schoolName;
  String? degree;
  String? description;

  Education({
    required this.startDate,
    this.endDate,
    this.logoURL,
    required this.schoolName,
    required this.degree,
    this.description,
  });

  factory Education.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final startDate = data['startDate'] as Timestamp;
      final endDate = data['endDate'] as Timestamp;
      final logoURL = data['logoURL'] as String;
      final schoolName = data['schoolName'] as String;
      final degree = data['degree'] as String;
      final description = data['description'] as String;

      return Education(
          startDate: startDate,
          endDate: endDate,
          logoURL: logoURL,
          schoolName: schoolName,
          degree: degree,
          description: description);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'logoURL': logoURL,
      'schoolName': schoolName,
      'degree': degree,
      'description': description,
    };
  }

  Future<void> create() async {
    try {
      await FirebaseFirestore.instance
        .collection('Education')
        .doc(schoolName)
        .set(toMap());
      print('Education document created');
    } catch (e) {
      print('Error creating education document: $e');
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('Education')
          .doc(schoolName)
          .update(toMap());
      return true;
    } catch (e) {
      print('Error updating education document: $e');
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance
        .collection('Education')
        .doc(schoolName)
        .delete();
      print('Education document deleted');
    } catch (e) {
      print('Error deleting education document: $e');
    }
  }
}
