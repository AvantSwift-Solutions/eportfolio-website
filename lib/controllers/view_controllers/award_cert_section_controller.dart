import 'dart:developer';

import '../../models/AwardCert.dart';
import '../../reposervice/award_cert_repo_services.dart'; // Import the AwardCert class

class AwardCertSectionController {
  final AwardCertRepoService awardCertRepoService;

  AwardCertSectionController(this.awardCertRepoService); // Constructor

  Future<List<AwardCert>?> getAwardCertList() async {
    try {
      List<AwardCert>? awardCerts =
          await awardCertRepoService.getAllAwardCert();
      return awardCerts;
    } catch (e) {
      log('Error getting AwardCert list: $e');
      return null;
    }
  }
}