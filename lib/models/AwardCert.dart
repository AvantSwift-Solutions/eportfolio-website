import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AwardCert {
  final String? acid;
  String? name;
  String? imageURL;
  String? link;
  String? source;
  Timestamp? creationTimestamp;
  

  AwardCert({
    required this.acid,
    required this.name,
    this.imageURL,
    required this.link,
    required this.source,
    this.creationTimestamp,
  });

  factory AwardCert.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final name = data['name'];
    final imageURL = data['imageURL'];
    final link = data['link'];
    final source = data['source'];
    final creationTimestamp = data['creationTimestamp'];

    return AwardCert(
      acid: snapshot.id,
      name: name,
      imageURL: imageURL,
      link: link,
      source: source,
      creationTimestamp: creationTimestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'acid': acid,
      'name': name,
      'imageURL': imageURL,
      'link': link,
      'source': source,
      'creationTimestamp': creationTimestamp,
    };
  }

  Future<void> create() async {
    try {
      final acid = const Uuid().v4();
      await FirebaseFirestore.instance.collection('AwardCert').doc(acid).set(toMap());
      print('AwardCert document created');
    } catch (e) {
      print('Error creating AwardCert document: $e');
    }
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('AwardCert')
          .doc(acid)
          .update(toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance.collection('AwardCert').doc(acid).delete();
      print('AwardCert document deleted');
    } catch (e) {
      print('Error deleting AwardCert document: $e');
    }
  }
}