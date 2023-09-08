import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Project {
  final String? ppid;
  String? name;
  String? description;
  Timestamp? creationTimestamp;
  String? imageURL;
  

  Project({
    required this.ppid,
    required this.name,
    this.description,
    this.creationTimestamp,
    this.imageURL,
  });

  factory Project.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final name = data['name'];
    final description = data['description'];
    final creationTimestamp = data['creationTimestamp'];
    final imageUrl = data['imageURL'];

    return Project(
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
      await FirebaseFirestore.instance.collection('Project').doc(ppid).set(toMap());
      print(' project document created');
    } catch (e) {
      print('Error creating  project document: $e');
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('Project')
          .doc(ppid)
          .update(toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('Project').doc(ppid).delete();
      print(' project document deleted');
    } catch (e) {
      print('Error deleting  project document: $e');
    }
  }
}
