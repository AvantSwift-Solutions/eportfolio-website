import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/AwardCert.dart';
import '../../reposervice/award_cert_repo_services.dart'; // Import the AwardCert class

class AwardCertAdminController {
  final AwardCertRepoService awardCertRepoService;

  AwardCertAdminController(this.awardCertRepoService); // Constructor

  Future <List<AwardCert>?> getAwardCertList() async {
    try {
      List<AwardCert>? awardCerts = await awardCertRepoService.getAllAwardCert();
      return awardCerts;
    } catch (e) {
      print('Error getting AwardCert list: $e');
      return null;
    }
  }

  
  Future<bool>? updateAwardCertData(int index, AwardCert newAwardCert) async {
    try {
      List<AwardCert>? awardCerts = await awardCertRepoService.getAllAwardCert();

      awardCerts?[index].name = newAwardCert.name;
      awardCerts?[index].imageURL = newAwardCert.imageURL;
      awardCerts?[index].link = newAwardCert.link;
      awardCerts?[index].source = newAwardCert.source;


      bool updateSuccess = await awardCerts?[index].update() ?? false;
      return updateSuccess;
    } catch (e) {
      print('Error updating awardCert: $e');
      return false;
    }
  }


  Future<bool> deleteAwardCert(int index) async {
    try {
      List<AwardCert>? awardCerts = await awardCertRepoService.getAllAwardCert();
      await awardCerts?[index].delete();
      return true;
    } catch (e) {
      print('Error deleting award cert: $e');
      return false;
    }
  }



  Future<String?> uploadImageAndGetURL(Uint8List imageBytes, String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/$fileName');
      final uploadTask = ref.putData(imageBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final imageURL = await snapshot.ref.getDownloadURL();
      return imageURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}