import 'package:avantswift_portfolio/constants.dart';
import 'package:avantswift_portfolio/controllers/view_controllers/project_section_controller.dart';
import 'package:avantswift_portfolio/models/Project.dart';
import 'package:avantswift_portfolio/view_pages/project_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';
import 'mocks/project_section_test.mocks.dart';

@GenerateMocks([Project, ProjectSectionController])
void main() {
  group('Project Section Widget Test', () {
    late MockProject mockProject1;
    late MockProject mockProject2;
    late MockProject mockProject3;
    late MockProject mockProject4;
    late MockProjectSectionController mockController; // Updated class name
    const String mockSectionDescription = 'Mock Description';

    setUp(() {
      mockProject1 = MockProject();
      mockProject2 = MockProject();
      mockProject3 = MockProject();
      mockProject4 = MockProject();

      when(mockProject1.creationTimestamp).thenReturn(Timestamp.now());
      when(mockProject1.ppid).thenReturn('mockid1');
      when(mockProject1.index).thenReturn(0);
      when(mockProject1.name).thenReturn('mock name1');
      when(mockProject1.description).thenReturn('mock desc1');
      when(mockProject1.link)
          .thenReturn('https://example.com/mock_project1.pdf');

      when(mockProject2.creationTimestamp).thenReturn(Timestamp.now());
      when(mockProject2.ppid).thenReturn('mockid2');
      when(mockProject2.index).thenReturn(1);
      when(mockProject2.name).thenReturn('mock name2');
      when(mockProject2.description).thenReturn('mock desc2');
      when(mockProject2.link)
          .thenReturn('https://example.com/mock_project2.pdf');

      when(mockProject3.creationTimestamp).thenReturn(Timestamp.now());
      when(mockProject3.ppid).thenReturn('mockid3');
      when(mockProject3.index).thenReturn(2);
      when(mockProject3.name).thenReturn('mock name3');
      when(mockProject3.description).thenReturn('mock desc3');
      when(mockProject3.link)
          .thenReturn('https://example.com/mock_project3.pdf');

      when(mockProject4.creationTimestamp).thenReturn(Timestamp.now());
      when(mockProject4.ppid).thenReturn('mockid4');
      when(mockProject4.index).thenReturn(3);
      when(mockProject4.name).thenReturn('mock name4');
      when(mockProject4.description).thenReturn('mock desc4');
      when(mockProject4.link)
          .thenReturn('https://example.com/mock_project4.pdf');

      mockController = MockProjectSectionController();
    });

    testWidgets('Project Section shows expected data',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      // FlutterError.onError = ignoreOverflowErrors;
      final mockProjectSectionData = [mockProject1, mockProject2, mockProject3];

      when(mockController.getProjectList())
          .thenAnswer((_) => Future.value(mockProjectSectionData));

      when(mockController.getSectionDescription())
          .thenAnswer((_) => Future.value(mockSectionDescription));

      // Build the widget
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ProjectSection(
              controller: mockController,
            ),
          ),
        );

        // Wait for the widget to load data
        await tester.pump();

        // Verify that the title text is displayed
        expect(find.text('Personal Projects'), findsOneWidget);

        // expect(find.textContaining(mockSectionDescription), findsOneWidget);

        // await tester.pumpAndSettle();

        // expect(find.byType(Card), findsAtLeastNWidgets(1));
        // expect(find.text(mockProject1.name!), findsOneWidget);
      });
    });
  });
}
// 