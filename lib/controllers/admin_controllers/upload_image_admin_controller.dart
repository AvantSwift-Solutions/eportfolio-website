import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImageAdminController {
  Future<String?> uploadImageAndGetURL(
      Uint8List imageBytes, String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final imageURL = await snapshot.ref.getDownloadURL();
      return imageURL;
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
