// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recommendation {
  Timestamp? creationTimestamp;
  final String? rid;
  int? index;
  String? colleagueName;
  String? colleagueJobTitle;
  String? description;
  String? imageURL;
  Timestamp? dateReceived;

  Recommendation({
    required this.creationTimestamp,
    required this.rid,
    required this.index,
    required this.description,
    required this.colleagueName,
    required this.colleagueJobTitle,
    required this.imageURL,
    required this.dateReceived,
  });

  factory Recommendation.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final creationTimestamp = data['creationTimestamp'];
      final index = data['index'];
      final colleagueName = data['colleagueName'];
      final colleagueJobTitle = data['colleagueJobTitle'];
      final description = data['description'];
      final imageURL = data['imageURL'];
      final dateReceived = data['dateReceived'];

      return Recommendation(
        creationTimestamp: creationTimestamp,
        rid: snapshot.id,
        index: index,
        colleagueName: colleagueName,
        colleagueJobTitle: colleagueJobTitle,
        description: description,
        imageURL: imageURL,
        dateReceived: dateReceived,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'creationTimestamp': creationTimestamp,
      'rid': rid,
      'index': index,
      'colleagueName': colleagueName,
      'colleagueJobTitle': colleagueJobTitle,
      'description': description,
      'imageURL': imageURL,
      'dateReceived': dateReceived,
    };
  }

  Future<bool> create(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Recommendation')
          .doc(id)
          .set(toMap());
      return true;
    } catch (e) {
      log('Error creating recommendation document: $e');
      return false;
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('Recommendation')
          .doc(rid)
          .update(toMap());
      return true;
    } catch (e) {
      log('Error updating recommendation document: $e');
      return false;
    }
  }

  Future<bool>? delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('Recommendation')
          .doc(rid)
          .delete();
      return true;
    } catch (e) {
      log('Error deleting recommendation document: $e');
      return false;
    }
  }
}
