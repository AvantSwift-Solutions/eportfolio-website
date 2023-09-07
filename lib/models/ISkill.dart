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

  Future<void> create() async {
    try {
      final isid = const Uuid().v4();
      await FirebaseFirestore.instance
          .collection('ISkill')
          .doc(isid)
          .set(toMap());
      print('ISkill document created');
    } catch (e) {
      print('Error creating ISkill document: $e');
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
      print('Error updating ISkill document: $e');
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('ISkill')
          .doc(isid)
          .delete();
      print('ISkill document deleted');
    } catch (e) {
      print('Error deleting ISkill document: $e');
    }
  }
}