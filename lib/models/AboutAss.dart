// ignore_for_file: file_names
// import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutAss {
  int? index;
  String? name;
  String? description;
  String? imageURL;

  AboutAss(
      {required this.name,
      required this.index,
      required this.description,
      required this.imageURL});

  factory AboutAss.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final name = data['name'] as String;
    final description = data['description'] as String;
    final imageURL = data['imageURL'] as String;
    final index = data['index'];

    return AboutAss(
        name: name, index: index, description: description, imageURL: imageURL);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'index': index,
      'description': description,
      'imageURL': imageURL,
    };
  }
}
