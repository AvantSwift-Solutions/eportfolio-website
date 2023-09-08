// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TSkill {
  final String? tsid;
  String? name;
  String? imageURL;

  TSkill({
    required this.tsid,
    required this.name,
    this.imageURL,
  });

  factory TSkill.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final name = data['name'];
    final imageURL = data['imageURL'];

    return TSkill(
      tsid: snapshot.id,
      name: name,
      imageURL: imageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tsid': tsid,
      'name': name,
      'imageURL': imageURL,
    };
  }

  Future<void> create() async {
    try {
      final tsid = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection('TSkill')
          .doc(tsid)
          .set(toMap());
    } catch (e) {
      log('Error creating TSkill document: $e');
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

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('TSkill').doc(tsid).delete();
    } catch (e) {
      log('Error deleting TSkill document: $e');
    }
  }
}
