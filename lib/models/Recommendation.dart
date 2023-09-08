// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Recommendation {
  final String? rid;
  String? colleagueName;
  String? colleagueJobTitle;
  String? description;
  String? imageURL;

  Recommendation({
    required this.rid,
    required this.description,
    required this.colleagueName,
    this.colleagueJobTitle,
    this.imageURL,
  });

  factory Recommendation.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final colleagueName = data['colleagueName'];
      final colleagueJobTitle = data['colleagueJobTitle'];
      final description = data['description'];
      final imageURL = data['imageURL'];

      return Recommendation(
        rid: snapshot.id,
        colleagueName: colleagueName,
        colleagueJobTitle: colleagueJobTitle,
        description: description,
        imageURL: imageURL,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'rid': rid,
      'colleagueName': colleagueName,
      'colleagueJobTitle': colleagueJobTitle,
      'description': description,
      'imageURL': imageURL,
    };
  }

  Future<void> create() async {
    try {
      final id = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection('Recommendation')
          .doc(id)
          .set(toMap());
    } catch (e) {
      log('Error creating recommendation document: $e');
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

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('Recommendation')
          .doc(rid)
          .delete();
    } catch (e) {
      log('Error deleting recommendation document: $e');
    }
  }
}
