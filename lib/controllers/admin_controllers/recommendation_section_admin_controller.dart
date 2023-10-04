import 'dart:developer';
import 'package:tuple/tuple.dart';
import '../../models/Recommendation.dart';
import '../../reposervice/recommendation_repo_services.dart';

class RecommendationSectionAdminController {
  final RecommendationRepoService recommendationRepoService;

  RecommendationSectionAdminController(
      this.recommendationRepoService); // Constructor

  Future<List<Recommendation>?>? getSectionData() async {
    try {
      List<Recommendation>? allRecommendations =
          await recommendationRepoService.getAllRecommendations();
      return allRecommendations;
    } catch (e) {
      log('Error getting Recommendation list: $e');
      return null;
    }
  }

  String getSectionName() {
    return 'Recommendations';
  }

  Future<List<Tuple2<int, String>>> getSectionTitles() async {
    List<Recommendation>? list = await getSectionData();
    var ret = <Tuple2<int, String>>[];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        ret.add(Tuple2(list[i].index!, 'From ${list[i].colleagueName!}'));
      }
    }
    return ret;
  }

  Future<void> updateSectionOrder(List<Tuple2<int, String>> items) async {
    List<Recommendation>? list = await getSectionData();
    if (list == null) return;
    for (var i = 0; i < items.length; i++) {
      var x = list[items[i].item1];
      x.index = i;
      await x.update();
    }
  }

  String defaultOrderName() {
    // Button will say 'Order _'
    return 'by Date Recieved';
  }

  Future<void> applyDefaultOrder() async {
    List<Recommendation>? list = await getSectionData();
    if (list == null) return;

    list.sort((a, b) {
      if (a.dateReceived == null && b.dateReceived == null) {
        return 0;
      } else if (a.dateReceived == null) {
        return -1;
      } else if (b.dateReceived == null) {
        return 1;
      } else {
        return b.dateReceived!.compareTo(a.dateReceived!);
      }
    });

    for (var i = 0; i < list.length; i++) {
      list[i].index = i;
      await list[i].update();
    }
  }

  Future<bool> deleteData(List<Recommendation> list, int index) async {
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
