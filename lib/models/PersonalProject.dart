import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalProject {
  String? ppid;
  String? name;
  String? description;
  final Timestamp? creationTimestamp;
  String? imageURL;
  

  PersonalProject({
    required this.ppid,
    required this.name,
    this.description,
    required this.creationTimestamp,
    this.imageURL,
  });

  factory PersonalProject.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      final ppid = data['ppid'] as String;
      final name = data['name'] as String;
      final description = data['description'] as String;
      final creationTimestamp = data['creationTimestamp'] as Timestamp;
      final imageUrl = data['imageURL'] as String;

      return PersonalProject(
          creationTimestamp: creationTimestamp,
          ppid: ppid,
          name: name,
          description: description,
          imageURL: imageUrl);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'ppid': ppid,
      'name': name,
      'description': description,
      'creationTimestamp': creationTimestamp,
      'imageURL': imageURL
    };
  }

  Future<String?> create() async {
    try {
      final documentReference  = await FirebaseFirestore.instance.collection('PersonalProject').add(toMap());
      print('Personal project document created');
      print(documentReference.id);
      return documentReference.id;
    } catch (e) {
      print('Error creating personal project document: $e');
      return null;
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('PersonalProject')
          .doc(ppid)
          .update(toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('PersonalProject').doc(ppid).delete();
      print('Personal project document deleted');
    } catch (e) {
      print('Error deleting personal project document: $e');
    }
  }
}
