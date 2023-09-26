import 'package:avantswift_portfolio/models/Recommendation.dart';
import 'package:avantswift_portfolio/reposervice/recommendation_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/recommendation_section_admin_controller.dart';
import 'package:tuple/tuple.dart';
import 'mocks/recommendation_section_admin_controller_test.mocks.dart';

@GenerateMocks([RecommendationRepoService])
class MockRecommendation extends Mock implements Recommendation {}

void main() {
  late MockRecommendation mockRecommendation1;
  late MockRecommendation mockRecommendation2;

  late RecommendationSectionAdminController controller;
  late RecommendationRepoService mockRepoService;

  setUp(() {
    mockRecommendation1 = MockRecommendation();
    when(mockRecommendation1.creationTimestamp).thenReturn(Timestamp.now());
    when(mockRecommendation1.rid).thenReturn('mockrid1');
    when(mockRecommendation1.index).thenReturn(0);
    when(mockRecommendation1.colleagueName).thenReturn('Mock Name1');
    when(mockRecommendation1.colleagueJobTitle).thenReturn('Mock Job Title1');
    when(mockRecommendation1.description).thenReturn('Mock Location1');
    when(mockRecommendation1.imageURL)
        .thenReturn('http://example.com/mock_image1.jpg');
    when(mockRecommendation1.dateReceived).thenReturn(Timestamp.now());

    mockRecommendation2 = MockRecommendation();
    when(mockRecommendation2.creationTimestamp).thenReturn(Timestamp.now());
    when(mockRecommendation2.rid).thenReturn('mockrid2');
    when(mockRecommendation2.index).thenReturn(1);
    when(mockRecommendation2.colleagueName).thenReturn('Mock Name2');
    when(mockRecommendation2.colleagueJobTitle).thenReturn('Mock Job Title2');
    when(mockRecommendation2.description).thenReturn('Mock Location2');
    when(mockRecommendation2.imageURL)
        .thenReturn('http://example.com/mock_image2.jpg');
    when(mockRecommendation2.dateReceived).thenReturn(Timestamp.now());

    mockRepoService = MockRecommendationRepoService();
    controller = RecommendationSectionAdminController(mockRepoService);
  });

  group('Recommendation section admin controller tests', () {
    test('getSectionData returns correct data when recommendation is not null',
        () async {
      when(mockRepoService.getAllRecommendations())
          .thenAnswer((_) async => [mockRecommendation1, mockRecommendation2]);
      final getAllRecommendations = await controller.getSectionData();

      // Make assertions on the returned data
      expect(getAllRecommendations!.length, 2);

      var rec1 = getAllRecommendations[0];
      var rec2 = getAllRecommendations[1];

      expect(rec1.creationTimestamp, mockRecommendation1.creationTimestamp);
      expect(rec1.rid, mockRecommendation1.rid);
      expect(rec1.index, mockRecommendation1.index);
      expect(rec1.colleagueName, mockRecommendation1.colleagueName);
      expect(rec1.colleagueJobTitle, mockRecommendation1.colleagueJobTitle);
      expect(rec1.description, mockRecommendation1.description);
      expect(rec1.imageURL, mockRecommendation1.imageURL);
      expect(rec1.dateReceived, mockRecommendation1.dateReceived);

      expect(rec2.creationTimestamp, mockRecommendation2.creationTimestamp);
      expect(rec2.rid, mockRecommendation2.rid);
      expect(rec2.index, mockRecommendation2.index);
      expect(rec2.colleagueName, mockRecommendation2.colleagueName);
      expect(rec2.colleagueJobTitle, mockRecommendation2.colleagueJobTitle);
      expect(rec2.description, mockRecommendation2.description);
      expect(rec2.imageURL, mockRecommendation2.imageURL);
      expect(rec2.dateReceived, mockRecommendation2.dateReceived);
    });

    test('getSectionData returns null data when recommendation is null',
        () async {
      when(mockRepoService.getAllRecommendations())
          .thenAnswer((_) async => null);
      final recommendationSectionData = await controller.getSectionData();
      expect(recommendationSectionData, null);
    });

    test('getSectionData returns null data on exception', () async {
      when(mockRepoService.getAllRecommendations())
          .thenThrow(Exception('Test Exception'));
      final recommendationSectionData = await controller.getSectionData();
      expect(recommendationSectionData, null);
    });

    test('getSectionName returns correct name', () {
      final sectionName = controller.getSectionName();
      expect(sectionName, 'Recommendations');
    });

    test('returns empty list when section data is null', () async {
      when(controller.getSectionData()).thenAnswer((_) => Future.value(null));
      final titles = await controller.getSectionTitles();
      expect(titles, isEmpty);
    });

    test('returns list of titles when section data is not null', () async {
      when(controller.getSectionData()).thenAnswer(
          (_) => Future.value([mockRecommendation1, mockRecommendation2]));
      final titles = await controller.getSectionTitles();
      expect(titles, [
        Tuple2(mockRecommendation1.index,
            'From ${mockRecommendation1.colleagueName}'),
        Tuple2(mockRecommendation2.index,
            'From ${mockRecommendation2.colleagueName}'),
      ]);
    });

    test('updateSectionOrder should update the indicies', () async {
      final items = [
        const Tuple2<int, String>(0, 'item1'),
        const Tuple2<int, String>(1, 'item2')
      ];
      final exps = [mockRecommendation1, mockRecommendation2];
      when(controller.getSectionData()).thenAnswer((_) async => exps);
      when(mockRecommendation1.update()).thenAnswer((_) async => true);
      when(mockRecommendation2.update()).thenAnswer((_) async => true);

      await controller.updateSectionOrder(items);

      verifyInOrder([
        mockRecommendation1.index = 0,
        mockRecommendation1.update(),
        mockRecommendation2.index = 1,
        mockRecommendation2.update(),
      ]);
    });

    test('defaultOrderName should return correctly', () {
      expect(controller.defaultOrderName(), 'by Date Recieved');
    });

    test('applyDefaultOrder should sort objects in default order', () async {
      MockRecommendation mockRecommendation3 = MockRecommendation();
      final list = [
        mockRecommendation3,
        mockRecommendation1,
        mockRecommendation2
      ];
      when(controller.getSectionData()).thenAnswer((_) async => list);
      when(mockRecommendation1.dateReceived)
          .thenReturn(Timestamp.fromMicrosecondsSinceEpoch(1));
      when(mockRecommendation2.dateReceived)
          .thenReturn(Timestamp.fromMicrosecondsSinceEpoch(2));
      when(mockRecommendation3.dateReceived).thenReturn(null);
      when(mockRecommendation1.update()).thenAnswer((_) async => true);
      when(mockRecommendation2.update()).thenAnswer((_) async => false);

      await controller.applyDefaultOrder();

      expect(list[0].dateReceived, null);
      expect(list[1].dateReceived, Timestamp.fromMicrosecondsSinceEpoch(2));
      expect(list[2].dateReceived, Timestamp.fromMicrosecondsSinceEpoch(1));
    });

    test(
        'deleteData should delete object at given index and update the index of remaining objects',
        () async {
      final list = [mockRecommendation1, mockRecommendation2];
      when(mockRecommendation1.index).thenReturn(0);
      when(mockRecommendation2.index).thenReturn(1);
      when(mockRecommendation1.update()).thenAnswer((_) async => true);
      when(mockRecommendation1.delete()).thenAnswer((_) async => true);
      when(mockRecommendation2.update()).thenAnswer((_) async => true);
      when(mockRecommendation2.delete()).thenAnswer((_) async => true);

      final result = await controller.deleteData(list, 0);

      verifyInOrder([
        mockRecommendation2.index = 0,
        mockRecommendation2.update(),
        mockRecommendation1.delete(),
      ]);
      expect(list[0].index, 0);
      expect(result, true);
    });

    test('deleteData should return false if deleting object fails', () async {
      final list = [mockRecommendation1];
      when(mockRecommendation1.delete()).thenThrow(Exception());

      final result = await controller.deleteData(list, 0);

      expect(result, false);
    });
  });
}
