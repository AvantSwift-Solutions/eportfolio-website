import 'package:avantswift_portfolio/controllers/view_controllers/recommendation_section_controller.dart';
import 'package:avantswift_portfolio/models/Recommendation.dart';
import 'package:avantswift_portfolio/view_pages/recommendation_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';
import 'mocks/recommendation_section_test.mocks.dart';
import 'view_pages_test_constants.dart';

@GenerateMocks([Recommendation, RecommendationSectionController])
void main() {
  group('Recommendation Section Widget Test', () {
    late MockRecommendation mockRecommendation1;
    late MockRecommendation mockRecommendation2;
    late MockRecommendation mockRecommendationFiller;
    late MockRecommendationSectionController
        mockController; // Updated class name

    setUp(() {
      mockRecommendation1 = MockRecommendation();
      when(mockRecommendation1.creationTimestamp).thenReturn(Timestamp.now());
      when(mockRecommendation1.description).thenReturn("Mock Description 1");
      when(mockRecommendation1.rid).thenReturn("mockId1");
      when(mockRecommendation1.index).thenReturn(0);
      when(mockRecommendation1.colleagueJobTitle)
          .thenReturn("Mock Colleague Job Title 1");
      when(mockRecommendation1.colleagueName)
          .thenReturn("Mock Colleague Name 1");
      when(mockRecommendation1.dateReceived).thenReturn(Timestamp.now());
      when(mockRecommendation1.imageURL)
          .thenReturn('http://example.com/mock_image1.jpg');

      mockRecommendation2 = MockRecommendation();
      when(mockRecommendation2.creationTimestamp).thenReturn(Timestamp.now());
      when(mockRecommendation2.description).thenReturn("Mock Description 2");
      when(mockRecommendation2.rid).thenReturn("mockId2");
      when(mockRecommendation2.index).thenReturn(2);
      when(mockRecommendation2.colleagueJobTitle)
          .thenReturn("Mock Colleague Job Title 2");
      when(mockRecommendation2.colleagueName)
          .thenReturn("Mock Colleague Name 2");
      when(mockRecommendation2.dateReceived).thenReturn(Timestamp.now());
      when(mockRecommendation2.imageURL)
          .thenReturn('http://example.com/mock_image2.jpg');

      mockRecommendationFiller = MockRecommendation();
      when(mockRecommendationFiller.creationTimestamp)
          .thenReturn(Timestamp.now());
      when(mockRecommendationFiller.description).thenReturn(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam in tortor vitae turpis dapibus aliquam. Vestibulum feugiat odio in leo rhoncus consequat. Integer commodo maximus nisi ac aliquet. Maecenas ut dui non nisi vestibulum tincidunt vel vel diam. Ut efficitur sem vitae eros condimentum, id mattis sem mattis. Curabitur laoreet, nisl quis sagittis interdum, nisi urna vulputate diam, et vulputate erat dolor nec diam. In a dictum turpis. Duis at est ornare, consectetur ex a, finibus lacus. In euismod nulla sit amet mauris hendrerit, eu sollicitudin felis molestie. Duis at libero imperdiet, dignissim lacus sit amet, fermentum tellus. Proin dolor leo, elementum in arcu vitae, finibus laoreet risus. Ut feugiat sit amet est sed efficitur. Maecenas eget orci ipsum.");
      when(mockRecommendationFiller.rid).thenReturn("mockIdFiller");
      when(mockRecommendationFiller.index).thenReturn(1);
      when(mockRecommendationFiller.colleagueJobTitle)
          .thenReturn("Mock Colleague Job Title Filler");
      when(mockRecommendationFiller.colleagueName)
          .thenReturn("Mock Colleague Name Filler");
      when(mockRecommendationFiller.dateReceived).thenReturn(Timestamp.now());
      when(mockRecommendationFiller.imageURL)
          .thenReturn('http://example.com/mock_imageFiller.jpg');

      mockController = MockRecommendationSectionController();
    });

    testWidgets('Recommendation Section shows expected data',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize =
          ViewPagesTestConstants.recommendationDesktopSize;
      tester.view.devicePixelRatio = 1.0;

      final mockRecommendationSectionData = [
        mockRecommendation1,
        mockRecommendation2
      ];

      when(mockController.getRecommendationSectionData())
          .thenAnswer((_) => Future.value(mockRecommendationSectionData));
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: RecommendationSection(
                  controller: mockController,
                ),
              ),
            ),
          ),
        );

        // Wait for the widget to load data
        await tester.pumpAndSettle();

        // Verify that the title text is displayed
        expect(find.text("Peer Recommendations"), findsOneWidget);

        expect(find.text(mockRecommendation1.colleagueName as String),
            findsOneWidget);
        expect(find.text(mockRecommendation1.colleagueJobTitle as String),
            findsOneWidget);
        expect(find.text('"${mockRecommendation1.description as String}"'),
            findsOneWidget);

        expect(find.text(mockRecommendation2.colleagueName as String),
            findsOneWidget);
        expect(find.text(mockRecommendation2.colleagueJobTitle as String),
            findsOneWidget);
        expect(find.text('"${mockRecommendation2.description as String}"'),
            findsOneWidget);

        expect(find.byType(CircleAvatar), findsNWidgets(2));
      });
    });

    testWidgets(
        'Recommendation Section has Multiple Pages which shows expected data',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize =
          ViewPagesTestConstants.recommendationDesktopSize;
      tester.view.devicePixelRatio = 1.0;

      final mockRecommendationSectionData = [
        mockRecommendation1,
        mockRecommendation1,
        mockRecommendation1,
        mockRecommendationFiller,
        mockRecommendationFiller,
        mockRecommendationFiller,
        mockRecommendationFiller,
        mockRecommendationFiller,
        mockRecommendationFiller,
        mockRecommendationFiller,
        mockRecommendation2
      ];

      when(mockController.getRecommendationSectionData())
          .thenAnswer((_) => Future.value(mockRecommendationSectionData));
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: RecommendationSection(
                  controller: mockController,
                ),
              ),
            ),
          ),
        );

        // Wait for the widget to load data
        await tester.pumpAndSettle();

        // Verify that the title text is displayed
        expect(find.text("Peer Recommendations"), findsOneWidget);
        final listFinder = find.byType(Scrollable).first;
        final itemFinder =
            find.text(mockRecommendation2.colleagueName as String);

        expect(find.text(mockRecommendation1.colleagueName as String),
            findsAtLeastNWidgets(3));
        expect(find.text(mockRecommendation1.colleagueJobTitle as String),
            findsAtLeastNWidgets(3));
        expect(find.text('"${mockRecommendation1.description as String}"'),
            findsAtLeastNWidgets(3));
        expect(find.byType(CircleAvatar), findsAtLeastNWidgets(3));

        // Scroll until the item to be found appears.
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );

        // Verify that the item contains the correct text.
        expect(itemFinder, findsOneWidget);

        final circleAvatarRec2 =
            tester.widget<CircleAvatar>(find.byType(CircleAvatar).first);
        expect(circleAvatarRec2.backgroundImage, isInstanceOf<NetworkImage>());
      });
    });
  });
}
