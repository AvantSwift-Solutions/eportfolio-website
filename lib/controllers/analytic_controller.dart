import 'package:avantswift_portfolio/models/Analytic.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticController {
  static Future<void> checkReset() async {
    Analytic analytic = await AnalyticRepoService().getAnalytic() ??
        Analytic(
            analyticId: '',
            month: Timestamp.now(),
            messages: 0,
            views: 0,
            lastEdit: Timestamp.now());

    if (!isSameMonth(analytic.month ?? Timestamp.now())) {
      analytic.month = Timestamp.now();
      analytic.views = 0;
      analytic.messages = 0;
    }

    analytic.update();
  }

  static bool isSameMonth(Timestamp month) {
    DateTime now = DateTime.now();
    DateTime monthDate = month.toDate();
    return now.month == monthDate.month && now.year == monthDate.year;
  }

  static Future<void> wasEdited() async {
    Analytic analytic = await AnalyticRepoService().getAnalytic() ??
        Analytic(
            analyticId: '',
            month: Timestamp.now(),
            messages: 0,
            views: 0,
            lastEdit: Timestamp.now());

    analytic.lastEdit = Timestamp.now();
    analytic.update();
    print(analytic.toMap());
  }

  static void incrementViews() async {
    Analytic analytic = await AnalyticRepoService().getAnalytic() ??
        Analytic(
            analyticId: '',
            month: Timestamp.now(),
            messages: 0,
            views: 0,
            lastEdit: Timestamp.now());

    if (isSameMonth(analytic.month ?? Timestamp.now())) {
      analytic.views++;
    } else {
      analytic.month = Timestamp.now();
      analytic.views = 1;
      analytic.messages = 1;
    }

    analytic.update();
  }

  static void incrementMessages() async {
    Analytic analytic = await AnalyticRepoService().getAnalytic() ??
        Analytic(
            analyticId: '',
            month: Timestamp.now(),
            messages: 0,
            views: 0,
            lastEdit: Timestamp.now());

    if (isSameMonth(analytic.month ?? Timestamp.now())) {
      analytic.messages++;
    } else {
      analytic.month = Timestamp.now();
      analytic.messages = 1;
      analytic.views = 0;
    }

    analytic.update();
  }
}
