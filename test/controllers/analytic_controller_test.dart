import 'package:avantswift_portfolio/controllers/analytic_controller.dart';
import 'package:avantswift_portfolio/models/Analytic.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAnalyticRepoService extends Mock implements AnalyticRepoService {}

void main() {
  group('AnalyticController', () {
    late MockAnalyticRepoService mockRepoService;
    late Analytic analytic;
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 32));

    setUp(() {
      mockRepoService = MockAnalyticRepoService();
      analytic = Analytic(
        analyticId: '1',
        month: Timestamp.fromDate(monthAgo),
        messages: 10,
        views: 20,
        lastEdit: Timestamp.fromDate(monthAgo),
      );
    });

    test('checkReset should update analytic if month is different', () async {
      
      
      when(mockRepoService.getAnalytic()).thenAnswer((_) async => analytic);

      Analytic res = await AnalyticController.checkReset(mockRepoService);

      verify(mockRepoService.getAnalytic()).called(1);
      expect(res.month?.toDate().month, equals(now.month));
      expect(res.views, 0);
      expect(res.messages, 0);

    });

    test('checkReset should not update analytic if month is same', () async {
      final analytic = Analytic(
        analyticId: '1',
        month: Timestamp.fromDate(now),
        messages: 10,
        views: 20,
        lastEdit: Timestamp.fromDate(now),
      );
      when(mockRepoService.getAnalytic()).thenAnswer((_) async => analytic);
      
      Analytic res = await AnalyticController.checkReset(mockRepoService);
      verify(mockRepoService.getAnalytic()).called(1);
      expect(res.views, equals(20));
      expect(res.messages, equals(10));
    });

    test('wasEdited should update lastEdit timestamp', () async {
      final analytic = Analytic(
        analyticId: '1',
        month: Timestamp.fromDate(now),
        messages: 10,
        views: 20,
        lastEdit: Timestamp.fromDate(now.subtract(const Duration(days: 1))),
      );
      when(mockRepoService.getAnalytic()).thenAnswer((_) async => analytic);

      await AnalyticController.wasEdited(mockRepoService);

      verify(mockRepoService.getAnalytic()).called(1);
      expect(analytic.lastEdit?.toDate().day, equals(now.day));

    });

    test('incrementViews should increment views count', () async {
      final analytic = Analytic(
        analyticId: '1',
        month: Timestamp.fromDate(now),
        messages: 10,
        views: 20,
        lastEdit: Timestamp.fromDate(now),
      );
      when(mockRepoService.getAnalytic()).thenAnswer((_) async => analytic);

      await AnalyticController.incrementViews(mockRepoService);

      verify(mockRepoService.getAnalytic()).called(1);
      expect(analytic.views, equals(21));
      expect(analytic.messages, equals(10));
    });

    test('incrementViews should reset views and messages count if month is different', () async {
      when(mockRepoService.getAnalytic()).thenAnswer((_) async => analytic);

      await AnalyticController.incrementViews(mockRepoService);

      verify(mockRepoService.getAnalytic()).called(1);
      expect(analytic.month?.toDate().month, equals(now.month));
      expect(analytic.views, equals(1));
      expect(analytic.messages, equals(1));
    });

    test('incrementMessages should increment messages count', () async {
      final analytic = Analytic(
        analyticId: '1',
        month: Timestamp.fromDate(now),
        messages: 10,
        views: 20,
        lastEdit: Timestamp.fromDate(now),
      );
      when(mockRepoService.getAnalytic()).thenAnswer((_) async => analytic);

      await AnalyticController.incrementMessages(mockRepoService);

      verify(mockRepoService.getAnalytic()).called(1);
      expect(analytic.views, equals(20));
      expect(analytic.messages, equals(11));
    });

    test('incrementMessages should reset views and messages count if month is different', () async {
      when(mockRepoService.getAnalytic()).thenAnswer((_) async => analytic);

      await AnalyticController.incrementMessages(mockRepoService);

      verify(mockRepoService.getAnalytic()).called(1);
      expect(analytic.month?.toDate().month, equals(now.month));
      expect(analytic.views, equals(0));
      expect(analytic.messages, equals(1));
    });
  });
}