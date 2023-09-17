// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class ISkill {
  Timestamp? creationTimestamp;
  final String? isid;
  int? index;
  String? name;

  ISkill({
    required this.creationTimestamp,
    required this.isid,
    required this.index,
    required this.name,
  });

  factory ISkill.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final creationTimestamp = data['creationTimestamp'];
    final index = data['index'];
    final name = data['name'];

    return ISkill(
      creationTimestamp: creationTimestamp,
      isid: snapshot.id,
      index: index,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creationTimestamp': creationTimestamp,
      'isid': isid,
      'index': index,
      'name': name,
    };
  }

  Future<bool> create(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('ISkill')
          .doc(id)
          .set(toMap());
      return true;
    } catch (e) {
      log('Error creating ISkill document: $e');
      return false;
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('ISkill')
          .doc(isid)
          .update(toMap());
      return true;
    } catch (e) {
      log('Error updating ISkill document: $e');
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await FirebaseFirestore.instance.collection('ISkill').doc(isid).delete();
      return true;
    } catch (e) {
      log('Error deleting ISkill document: $e');
      return false;
    }
  }
}
