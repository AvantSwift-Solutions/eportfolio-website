import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Reccomendation {
  final String? rid;
  String? colleagueName;
  String? colleagueJobTitle;
  String? description;
  String? imageURL; 

  Reccomendation({
    required this.rid,
    required this.description,
    required this.colleagueName,
    this.colleagueJobTitle,
    this.imageURL,
  });

  factory Reccomendation.fromDocumentSnapshot(DocumentSnapshot snapshot) {
  try {
    final data = snapshot.data() as Map<String, dynamic>;
    final colleagueName = data['colleagueName'];
    final colleagueJobTitle = data['colleagueJobTitle'];
    final description = data['description'];
    final imageURL = data['imageURL'];

    return Reccomendation(
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
      await FirebaseFirestore.instance.collection('Reccomendation').doc(id).set(toMap());
      print('Reccomendation document created');
    } catch (e) {
      print('Error creating reccomendation document: $e');
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('Reccomendation')
          .doc(rid)
          .update(toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('Reccomendation').doc(rid).delete();
      print('Reccomendation document deleted');
    } catch (e) {
      print('Error deleting reccomendation document: $e');
    }
  }

}
