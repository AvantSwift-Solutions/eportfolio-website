import 'package:avantswift_portfolio/controllers/view_controllers/interpersonal_skills_section_controller.dart';
import 'package:avantswift_portfolio/models/ISkill.dart';
import 'package:avantswift_portfolio/view_pages/interpersonal_skills_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';
import 'mocks/interpersonal_skills_section_test.mocks.dart';
import 'view_pages_test_constants.dart';

@GenerateMocks([ISkill, InterpersonalSkillsController])
void main() {
  group('Interpersonal Skill Widget Test', () {
    late MockISkill mockISkill1;
    late MockISkill mockISkill2;
    late MockISkill mockISkill3;
    late MockISkill mockISkill4;
    late MockInterpersonalSkillsController mockController;

    setUp(() {
      mockISkill1 = MockISkill();
      when(mockISkill1.creationTimestamp).thenReturn(Timestamp.now());
      when(mockISkill1.index).thenReturn(0);
      when(mockISkill1.isid).thenReturn("mockId1");
      when(mockISkill1.name).thenReturn("Mock Name 1");

      mockISkill2 = MockISkill();
      when(mockISkill2.creationTimestamp).thenReturn(Timestamp.now());
      when(mockISkill2.index).thenReturn(1);
      when(mockISkill2.isid).thenReturn("mockId2");
      when(mockISkill2.name).thenReturn("Mock Name 2");

      mockISkill3 = MockISkill();
      when(mockISkill3.creationTimestamp).thenReturn(Timestamp.now());
      when(mockISkill3.index).thenReturn(2);
      when(mockISkill3.isid).thenReturn("mockId3");
      when(mockISkill3.name).thenReturn("Mock Name 3");

      mockISkill4 = MockISkill();
      when(mockISkill4.creationTimestamp).thenReturn(Timestamp.now());
      when(mockISkill4.index).thenReturn(3);
      when(mockISkill4.isid).thenReturn("mockId4");
      when(mockISkill4.name).thenReturn("Mock Name 4");

      mockController = MockInterpersonalSkillsController();
    });

    testWidgets('Interpersonal Skill Widget shows expected data',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = ViewPagesTestConstants.iSkillDesktopSize;
      tester.view.devicePixelRatio = 1.0;
      // FlutterError.onError = ignoreOverflowErrors;
      final mockISkillData = [
        mockISkill1.name as String,
        mockISkill2.name as String,
        mockISkill3.name as String,
        mockISkill4.name as String
      ];

      when(mockController.getIPersonalSkills())
          .thenAnswer((_) => Future.value(mockISkillData));

      // Build the widget
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: InterpersonalSkillsWidget(
                  controller: mockController,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that the title text is displayed
        expect(find.text('Interpersonal Skills'), findsOneWidget);

        expect(find.text(mockISkill1.name as String), findsOneWidget);
        expect(find.text(mockISkill2.name as String), findsOneWidget);
        expect(find.text(mockISkill3.name as String), findsOneWidget);
        expect(find.text(mockISkill4.name as String), findsOneWidget);
      });
    });

    testWidgets(
        'Interpersonal Skill Widget shows expected data with multiple pages',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = ViewPagesTestConstants.iSkillDesktopSize;
      tester.view.devicePixelRatio = 1.0;
      // FlutterError.onError = ignoreOverflowErrors;
      final mockISkillData = [
        mockISkill1.name as String,
        mockISkill1.name as String,
        mockISkill1.name as String,
        mockISkill1.name as String,
        mockISkill1.name as String,
        mockISkill1.name as String,
        mockISkill2.name as String,
      ];

      when(mockController.getIPersonalSkills())
          .thenAnswer((_) => Future.value(mockISkillData));

      // Build the widget
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: InterpersonalSkillsWidget(
                  controller: mockController,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that the title text is displayed
        expect(find.text('Interpersonal Skills'), findsOneWidget);

        expect(find.text(mockISkill1.name as String), findsNWidgets(6));
        expect(find.text(mockISkill2.name as String), findsNothing);

        await tester.fling(
            find.byType(PageView), const Offset(-200.0, 0.0), 1000.0);
        await tester.pumpAndSettle();
        expect(find.text(mockISkill1.name as String), findsNothing);
        expect(find.text(mockISkill2.name as String), findsOneWidget);
      });
    });
  });
}
