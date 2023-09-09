// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ISkill {
  final String? isid;
  String? name;

  ISkill({
    required this.isid,
    required this.name,
  });

  factory ISkill.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final name = data['name'];

    return ISkill(
      isid: snapshot.id,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isid': isid,
      'name': name,
    };
  }

  Future<bool> create() async {
    try {
      final isid = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection('ISkill')
          .doc(isid)
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
