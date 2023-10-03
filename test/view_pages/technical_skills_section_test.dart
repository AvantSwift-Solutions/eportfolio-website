import 'package:avantswift_portfolio/controllers/view_controllers/technical_skills_controller.dart';
import 'package:avantswift_portfolio/models/TSkill.dart';
import 'package:avantswift_portfolio/ui/tskill_image.dart';
import 'package:avantswift_portfolio/view_pages/technical_skills_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';
import 'mocks/technical_skills_section_test.mocks.dart';

@GenerateMocks([TSkill, TechnicalSkillsController])
void main() {
  group('Interpersonal Skill Widget Test', () {
    late MockTSkill mockTSkill1;
    late MockTSkill mockTSkill2;
    late MockTechnicalSkillsController mockController;

    setUp(() {
      mockTSkill1 = MockTSkill();
      when(mockTSkill1.creationTimestamp).thenReturn(Timestamp.now());
      when(mockTSkill1.index).thenReturn(0);
      when(mockTSkill1.tsid).thenReturn("mockId1");
      when(mockTSkill1.name).thenReturn("Mock Name 1");
      when(mockTSkill1.imageURL)
          .thenReturn('http://example.com/mock_image1.jpg');

      mockTSkill2 = MockTSkill();
      when(mockTSkill2.creationTimestamp).thenReturn(Timestamp.now());
      when(mockTSkill2.index).thenReturn(1);
      when(mockTSkill2.tsid).thenReturn("mockId2");
      when(mockTSkill2.name).thenReturn("Mock Name 2");
      when(mockTSkill2.imageURL)
          .thenReturn('http://example.com/mock_image2.jpg');

      mockController = MockTechnicalSkillsController();
    });

    testWidgets('Interpersonal Skill Widget shows expected data',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      // FlutterError.onError = ignoreOverflowErrors;
      final mockTSkillData = [
        Image.network(mockTSkill1.imageURL as String),
        Image.network(mockTSkill2.imageURL as String),
      ];

      when(mockController.getTechnicalSkillImages())
          .thenAnswer((_) => Future.value(mockTSkillData));

      when(mockController.getCentralImage()).thenAnswer((_) => Future.value(
          Image.network('http://example.com/mock_central_image.jpg')));

      // Build the widget
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: TechnicalSkillsWidget(
                  controller: mockController,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // // Verify that the title text is displayed
        expect(find.text('Technical Skills'), findsOneWidget);

        expect(find.byType(TSkillsImage), findsOneWidget);

        // 1 Center image and 2 skills image
        expect(find.byType(Image), findsNWidgets(3));
      });
    });
  });
}
