// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  Timestamp? creationTimestamp;
  final String? ppid;
  int? index;
  String? name;
  String? description;
<<<<<<< HEAD
  Timestamp? creationTimestamp;
=======
>>>>>>> main
  String? link;

  Project({
    required this.creationTimestamp,
    required this.ppid,
    required this.index,
    required this.name,
<<<<<<< HEAD
    this.description,
    this.creationTimestamp,
    this.link,
=======
    required this.description,
    required this.link,
>>>>>>> main
  });

  factory Project.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final creationTimestamp = data['creationTimestamp'];
    final index = data['index'];
    final name = data['name'];
    final description = data['description'];
<<<<<<< HEAD
    final creationTimestamp = data['creationTimestamp'];
=======
>>>>>>> main
    final link = data['link'];

    return Project(
      creationTimestamp: creationTimestamp,
      index: index,
      ppid: snapshot.id,
      name: name,
      description: description,
<<<<<<< HEAD
      creationTimestamp: creationTimestamp,
=======
>>>>>>> main
      link: link,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creationTimestamp': creationTimestamp,
      'ppid': ppid,
      'index': index,
      'name': name,
      'description': description,
<<<<<<< HEAD
      'creationTimestamp': creationTimestamp,
=======
>>>>>>> main
      'link': link
    };
  }

  Future<bool> create(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Project')
          .doc(id)
          .set(toMap());
      return true;
    } catch (e) {
      log('Error creating project document: $e');
      return false;
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
      log('Error updating project document: $e');
      return false;
    }
  }

  Future<bool>? delete() async {
    try {
      await FirebaseFirestore.instance.collection('Project').doc(ppid).delete();
      return true;
    } catch (e) {
      log('Error deleting project document: $e');
      return false;
    }
  }
}
