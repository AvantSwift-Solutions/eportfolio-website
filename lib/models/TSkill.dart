// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class TSkill {
  Timestamp? creationTimestamp;
  final String? tsid;
  int? index;
  String? name;
  String? imageURL;

  TSkill({
    required this.creationTimestamp,
    required this.tsid,
    required this.index,
    required this.name,
    required this.imageURL,
  });

  factory TSkill.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final creationTimestamp = data['creationTimestamp'];
    final tsid = data['tsid'];
    final index = data['index'];
    final name = data['name'];
    final imageURL = data['imageURL'];

    return TSkill(
      creationTimestamp: creationTimestamp,
      tsid: tsid,
      index: index,
      name: name,
      imageURL: imageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creationTimestamp': creationTimestamp,
      'tsid': tsid,
      'index': index,
      'name': name,
      'imageURL': imageURL,
    };
  }

  Future<bool> create(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('TSkill')
          .doc(id)
          .set(toMap());
      return true;
    } catch (e) {
      log('Error creating TSkill document: $e');
      return false;
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('TSkill')
          .doc(tsid)
          .update(toMap());
      return true;
    } catch (e) {
      log('Error updating TSkill document: $e');
      return false;
    }
  }

  Future<bool>? delete() async {
    try {
      await FirebaseFirestore.instance.collection('TSkill').doc(tsid).delete();
      return true;
    } catch (e) {
      log('Error deleting TSkill document: $e');
      return false;
    }
  }
}
