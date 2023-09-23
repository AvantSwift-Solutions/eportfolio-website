// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  Timestamp? creationTimestamp;
  final String? ppid;
  int? index;
  String? name;
  String? description;
  String? link;

  Project({
    required this.creationTimestamp,
    required this.ppid,
    required this.index,
    required this.name,
    required this.description,
    required this.link,
  });

  factory Project.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final creationTimestamp = data['creationTimestamp'];
    final index = data['index'];
    final name = data['name'];
    final description = data['description'];
    final link = data['link'];

    return Project(
      creationTimestamp: creationTimestamp,
      index: index,
      ppid: snapshot.id,
      name: name,
      description: description,
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
