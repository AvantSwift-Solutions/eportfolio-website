import 'package:avantswift_portfolio/models/Analytic.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticController {
  static final defaultAnalytic = Analytic(
            analyticId: '',
            month: Timestamp.now(),
            messages: -1,
            views: -1,
            lastEdit: Timestamp.now());

  static Future<Analytic> checkReset(AnalyticRepoService repoService) async {
    Analytic analytic = await repoService.getAnalytic() ?? defaultAnalytic;

    if (!isSameMonth(analytic.month ?? Timestamp.now())) {
      analytic.month = Timestamp.now();
      analytic.views = 0;
      analytic.messages = 0;
    }

    analytic.update();

    return analytic;
  }

  static bool isSameMonth(Timestamp month) {
    DateTime now = DateTime.now();
    DateTime monthDate = month.toDate();
    return now.month == monthDate.month && now.year == monthDate.year;
  }

  static Future<void> wasEdited(AnalyticRepoService repoService) async {
    Analytic analytic = await repoService.getAnalytic() ??defaultAnalytic;

    analytic.lastEdit = Timestamp.now();
    analytic.update();
  }

  static Future<void> incrementViews(AnalyticRepoService repoService) async {
    Analytic analytic = await repoService.getAnalytic() ??defaultAnalytic;

    if (isSameMonth(analytic.month ?? Timestamp.now())) {
      analytic.views ??= 0;
      analytic.views = analytic.views! + 1;
    } else {
      analytic.month = Timestamp.now();
      analytic.views = 1;
      analytic.messages = 1;
    }

    analytic.update();
  }

  static Future<void> incrementMessages(AnalyticRepoService repoService) async {
    Analytic analytic = await repoService.getAnalytic() ??defaultAnalytic;

    if (isSameMonth(analytic.month ?? Timestamp.now())) {
      analytic.messages ??= 0;
      analytic.messages = analytic.messages! + 1;
    } else {
      analytic.month = Timestamp.now();
      analytic.messages = 1;
      analytic.views = 0;
    }

    analytic.update();
  }
}
