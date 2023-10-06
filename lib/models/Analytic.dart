// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Analytic {
  final String? analyticId;
  Timestamp? month;
  int messages;
  int views;
  Timestamp? lastEdit;

  Analytic({
    required this.analyticId,
    required this.month,
    required this.messages,
    required this.views,
    required this.lastEdit,
  });

  factory Analytic.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final analyticId = data['analyticId'] as String;
    final month = data['month'];
    final messages = data['messages'];
    final views = data['views'];
    final lastEdit = data['lastEdit'];

    return Analytic(
      analyticId: analyticId,
      month: month,
      messages: messages,
      views: views,
      lastEdit: lastEdit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'messages': messages,
      'views': views,
      'lastEdit': lastEdit,
    };
  }

  Future<bool>? update() async {
    try {
      await FirebaseFirestore.instance
          .collection('Analytic')
          .doc(analyticId)
          .update(toMap());
      return true;
    } catch (e) {
      log('Error updating Analytic document: $e');
      return false;
    }
  }
}
