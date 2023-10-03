import 'package:avantswift_portfolio/controllers/view_controllers/education_section_controller.dart';
import 'package:avantswift_portfolio/dto/education_section_dto.dart';
import 'package:avantswift_portfolio/view_pages/education_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/Education.dart';
import 'package:run_with_network_images/run_with_network_images.dart';
import 'mocks/education_section_test.mocks.dart';

// Function to format Timestamp to "Month Year" format
String formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) {
    return "Null Timestamp";
  }
  final DateTime dateTime = timestamp.toDate();
  final String formattedDate = DateFormat.yMMM().format(dateTime);
  return formattedDate;
}

String formatEndDateTimestamp(Timestamp? timestamp) {
  if (timestamp == null) {
    return "Present";
  }

  return formatTimestamp(timestamp);
}

const Duration _frameDuration = Duration(milliseconds: 100);

@GenerateMocks([Education, EducationSectionController])
void main() {
  group('Experience Section Widget Test', () {
    late MockEducation mockEducation1;
    late MockEducation mockEducation2;
    late MockEducation mockEducation3;
    late MockEducationSectionController mockController; // Updated class name

    setUp(() {
      mockEducation1 = MockEducation();
      when(mockEducation1.creationTimestamp).thenReturn(Timestamp.now());
      when(mockEducation1.degree).thenReturn("Mock Degree 1");
      when(mockEducation1.description).thenReturn("Mock Description 1");
      when(mockEducation1.eid).thenReturn("mockId1");
      when(mockEducation1.degree).thenReturn("Mock Degree 1");
      when(mockEducation1.grade).thenReturn(90.0);
      when(mockEducation1.gradeDescription)
          .thenReturn("Mock Grade Description 1");
      when(mockEducation1.index).thenReturn(0);
      when(mockEducation1.major).thenReturn("Mock Major 1");
      when(mockEducation1.schoolName).thenReturn("Mock School Name 1");
      when(mockEducation1.startDate).thenReturn(Timestamp.now());
      when(mockEducation1.endDate).thenReturn(Timestamp.now());
      when(mockEducation1.logoURL)
          .thenReturn('http://example.com/mock_image1.jpg');

      mockEducation2 = MockEducation();
      when(mockEducation2.creationTimestamp).thenReturn(Timestamp.now());
      when(mockEducation2.degree).thenReturn("Mock Degree 2");
      when(mockEducation2.description).thenReturn("Mock Description 2");
      when(mockEducation2.eid).thenReturn("mockId2");
      when(mockEducation2.degree).thenReturn("Mock Degree 2");
      when(mockEducation2.grade).thenReturn(85.0);
      when(mockEducation2.gradeDescription)
          .thenReturn("Mock Grade Description 2");
      when(mockEducation2.index).thenReturn(1);
      when(mockEducation2.major).thenReturn("Mock Major 2");
      when(mockEducation2.schoolName).thenReturn("Mock School Name 2");
      when(mockEducation2.startDate).thenReturn(Timestamp.now());
      when(mockEducation2.endDate).thenReturn(Timestamp.now());
      when(mockEducation2.logoURL)
          .thenReturn('http://example.com/mock_image2.jpg');

      mockEducation3 = MockEducation();
      when(mockEducation3.creationTimestamp).thenReturn(Timestamp.now());
      when(mockEducation3.degree).thenReturn("Mock Degree 3");
      when(mockEducation3.description).thenReturn("Mock Description 3");
      when(mockEducation3.eid).thenReturn("mockId3");
      when(mockEducation3.degree).thenReturn("Mock Degree 3");
      when(mockEducation3.grade).thenReturn(80.0);
      when(mockEducation3.gradeDescription)
          .thenReturn("Mock Grade Description 3");
      when(mockEducation3.index).thenReturn(2);
      when(mockEducation3.major).thenReturn("Mock Major 3");
      when(mockEducation3.schoolName).thenReturn("Mock School Name 3");
      when(mockEducation3.startDate).thenReturn(Timestamp.now());
      when(mockEducation3.endDate).thenReturn(Timestamp.now());
      when(mockEducation3.logoURL)
          .thenReturn('http://example.com/mock_image3.jpg');

      mockController = MockEducationSectionController();
    });

    testWidgets('Education Section shows expected data',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      final mockEducationSectionData = [
        EducationDTO(
          schoolName: mockEducation1.schoolName,
          degree: mockEducation1.degree,
          grade: mockEducation1.grade,
          gradeDescription: mockEducation1.gradeDescription,
          major: mockEducation1.major,
          startDate: formatTimestamp(mockEducation1.startDate),
          endDate: formatEndDateTimestamp(mockEducation1.endDate),
          description: mockEducation1.description,
          logoURL: mockEducation1.logoURL,
          index: mockEducation1.index,
        ),
        EducationDTO(
          schoolName: mockEducation2.schoolName,
          degree: mockEducation2.degree,
          grade: mockEducation2.grade,
          gradeDescription: mockEducation2.gradeDescription,
          major: mockEducation2.major,
          startDate: formatTimestamp(mockEducation2.startDate),
          endDate: formatEndDateTimestamp(mockEducation2.endDate),
          description: mockEducation2.description,
          logoURL: mockEducation2.logoURL,
          index: mockEducation2.index,
        ),
        EducationDTO(
          schoolName: mockEducation3.schoolName,
          degree: mockEducation3.degree,
          grade: mockEducation3.grade,
          gradeDescription: mockEducation3.gradeDescription,
          major: mockEducation3.major,
          startDate: formatTimestamp(mockEducation3.startDate),
          endDate: formatEndDateTimestamp(mockEducation3.endDate),
          description: mockEducation3.description,
          logoURL: mockEducation3.logoURL,
          index: mockEducation3.index,
        ),
      ];

      when(mockController.getEducationSectionData())
          .thenAnswer((_) => Future.value(mockEducationSectionData));

      // Build the widget
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: EducationSection(
              controller: mockController,
            ),
          ),
        );

        // Wait for the widget to load data
        await tester.pumpAndSettle();

        // Verify that the title text is displayed
        expect(find.text("Education History"), findsOneWidget);

        expect(
            find.byType(EducationWidget),
            findsAtLeastNWidgets(
                2)); // Assuming you want to display 2 experiences initially

        expect(find.text(mockEducation1.schoolName as String), findsOneWidget);
        expect(find.text(mockEducation2.schoolName as String), findsOneWidget);
        expect(find.text(mockEducation3.schoolName as String), findsNothing);

        await tester.fling(
            find.byType(PageView), const Offset(-200.0, 0.0), 1000.0);
        await tester.pumpAndSettle(_frameDuration);

        expect(
            find.byType(EducationWidget),
            findsAtLeastNWidgets(
                1)); // Assuming you want to display 2 experiences initially
        expect(find.text(mockEducation1.schoolName as String), findsNothing);
        expect(find.text(mockEducation2.schoolName as String), findsNothing);
        expect(find.text(mockEducation3.schoolName as String), findsOneWidget);
      });
    });

    group("Education Widget Tests", () {
      testWidgets('Education Widget shows expected data',
          (WidgetTester tester) async {
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = const Size(1920, 1080);
        final mockEducationWidgetData = EducationDTO(
          schoolName: mockEducation1.schoolName,
          degree: mockEducation1.degree,
          grade: mockEducation1.grade,
          gradeDescription: mockEducation1.gradeDescription,
          major: mockEducation1.major,
          startDate: formatTimestamp(mockEducation1.startDate),
          endDate: formatEndDateTimestamp(mockEducation1.endDate),
          description: mockEducation1.description,
          logoURL: mockEducation1.logoURL,
          index: mockEducation1.index,
        );

        // Build the ExperienceWidget with the mock data
        await runWithNetworkImages(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: EducationWidget(
                educationDTO: mockEducationWidgetData,
                itemsPerPage: 2,
                numEducation: 3,
              ),
            ),
          );

          // Use the `expect` function to make assertions
          // Example: Check if the job title is displayed correctly
          expect(
              find.text(mockEducation1.schoolName as String), findsOneWidget);
          expect(find.text(mockEducation1.major as String), findsOneWidget);
          expect(find.text(mockEducation1.degree as String), findsOneWidget);
          expect(
              find.text(
                  'Grade: ${mockEducation1.grade} - ${mockEducation1.gradeDescription}'),
              findsOneWidget);

          expect(
              find.text(
                  '${formatTimestamp(mockEducation1.startDate)} - ${formatEndDateTimestamp(mockEducation1.endDate)}'),
              findsOneWidget);

          expect(
              find.text(mockEducation1.description as String), findsOneWidget);

          // Find the Image.network widget using a Key or another appropriate method
          final imageWidget = find.byType(Image);

          // Verify that the widget is present in the widget tree
          expect(imageWidget, findsOneWidget);

          // You can also check other properties of the Image widget if needed
          final image = tester.widget<Image>(imageWidget);
          expect(image.fit, BoxFit.cover);

          // Trigger a frame rebuild to ensure that the image loads
          await tester.pump();

          // You can also check if the image URL is correct (assuming _imageURL is available)
          // Replace 'your_image_url_here' with the expected image URL
          final expectedImageUrl = mockEducationWidgetData.logoURL;
          expect(image.image, isA<NetworkImage>());
          expect((image.image as NetworkImage).url, expectedImageUrl);
        });
      });
    });

    testWidgets('Experience Widget End Date is Present when Null',
        (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1920, 1080);
      final mockEducationWidgetData = EducationDTO(
        schoolName: mockEducation1.schoolName,
        degree: mockEducation1.degree,
        grade: mockEducation1.grade,
        gradeDescription: mockEducation1.gradeDescription,
        major: mockEducation1.major,
        startDate: formatTimestamp(mockEducation1.startDate),
        endDate: formatEndDateTimestamp(null),
        description: mockEducation1.description,
        logoURL: mockEducation1.logoURL,
        index: mockEducation1.index,
      );

      // Build the ExperienceWidget with the mock data
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: EducationWidget(
              educationDTO: mockEducationWidgetData,
              itemsPerPage: 2,
              numEducation: 3,
            ),
          ),
        );

        expect(
            find.text('${formatTimestamp(mockEducation1.startDate)} - Present'),
            findsOneWidget);
      });
    });
  });
}
