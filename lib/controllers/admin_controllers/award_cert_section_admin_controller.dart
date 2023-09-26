import 'dart:developer';
import 'package:tuple/tuple.dart';
import '../../models/AwardCert.dart';
import '../../reposervice/award_cert_repo_services.dart';

class AwardCertSectionAdminController {
  final AwardCertRepoService awardCertRepoService;

  AwardCertSectionAdminController(this.awardCertRepoService);

  Future<List<AwardCert>?> getSectionData() async {
    try {
      List<AwardCert>? awardCerts =
          await awardCertRepoService.getAllAwardCert();
      return awardCerts;
    } catch (e) {
      log('Error getting AwardCert list: $e');
      return null;
    }
  }

  String getSectionName() {
    return 'Awards & Certifications';
  }

  Future<List<Tuple2<int, String>>> getSectionTitles() async {
    List<AwardCert>? list = await getSectionData();
    var ret = <Tuple2<int, String>>[];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        ret.add(
            Tuple2(list[i].index!, '${list[i].name} from ${list[i].source}'));
      }
    }
    return ret;
  }

  Future<void> updateSectionOrder(List<Tuple2<int, String>> items) async {
    List<AwardCert>? exps = await getSectionData();
    if (exps == null) return;
    for (var i = 0; i < items.length; i++) {
      var skill = exps[items[i].item1];
      skill.index = i;
      await skill.update();
    }
  }

  String defaultOrderName() {
    // Button will say 'Order _'
    return 'by Date Issued';
  }

  Future<void> applyDefaultOrder() async {
    List<AwardCert>? list = await getSectionData();
    if (list == null) return;

    list.sort((a, b) {
      if (a.dateIssued == null && b.dateIssued == null) {
        return 0;
      } else if (a.dateIssued == null) {
        return -1;
      } else if (b.dateIssued == null) {
        return 1;
      } else {
        return b.dateIssued!.compareTo(a.dateIssued!);
      }
    });

    for (var i = 0; i < list.length; i++) {
      list[i].index = i;
      await list[i].update();
    }
  }

  Future<bool> deleteData(List<AwardCert> list, int index) async {
    for (var i = index + 1; i < list.length; i++) {
      list[i].index = list[i].index! - 1;
      await list[i].update();
    }

    try {
      await list[index].delete();
      return true;
    } catch (e) {
      log('Error deleting: $e');
      return false;
    }
  }

}
