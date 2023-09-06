import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class PersonalProject {
  final String ppid;
  String name;
  String? description;
  Timestamp? creationTimestamp;
  String? imageURL;
  

  PersonalProject({
    required this.ppid,
    required this.name,
    this.description,
    required this.creationTimestamp,
    this.imageURL,
  });

  factory PersonalProject.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final name = data['name'];
    final description = data['description'];
    final creationTimestamp = data['creationTimestamp'];
    final imageUrl = data['imageURL'];

    return PersonalProject(
      ppid: snapshot.id,
      name: name,
      description: description,
      creationTimestamp: creationTimestamp,
      imageURL: imageUrl,
    );
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

  Future<void> create() async {
    try {
      final ppid = const Uuid().v4();
      await FirebaseFirestore.instance.collection('PersonalProject').doc(ppid).set(toMap());
      print('Personal project document created');
    } catch (e) {
      print('Error creating personal project document: $e');
    }
  }

  Future<bool> update() async {
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
