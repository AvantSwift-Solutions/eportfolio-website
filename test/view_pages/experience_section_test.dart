import 'package:avantswift_portfolio/controllers/view_controllers/experience_section_controller.dart';
import 'package:avantswift_portfolio/dto/experience_dto.dart';
import 'package:avantswift_portfolio/models/Experience.dart';
import 'package:avantswift_portfolio/ui/custom_view_more_button.dart';
import 'package:avantswift_portfolio/view_pages/experience_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';
import 'mocks/experience_section_test.mocks.dart';
import 'view_pages_test_constants.dart';

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

@GenerateMocks([Experience, ExperienceSectionController])
void main() {
  group('Experience Section Widget Test', () {
    late MockExperience mockExperience1;
    late MockExperience mockExperience2;
    late MockExperience mockExperience3;
    late MockExperience mockExperience4;
    late MockExperienceSectionController mockController; // Updated class name

    setUp(() {
      mockExperience1 = MockExperience();
      when(mockExperience1.creationTimestamp).thenReturn(Timestamp.now());
      when(mockExperience1.peid).thenReturn('mockId1');
      when(mockExperience1.index).thenReturn(1);
      when(mockExperience1.jobTitle).thenReturn('Mock JobTitle1');
      when(mockExperience1.employmentType).thenReturn('Mock EmploymentType1');
      when(mockExperience1.companyName).thenReturn('Mock CompanyName1');
      when(mockExperience1.location).thenReturn('Mock Location1');
      when(mockExperience1.startDate).thenReturn(Timestamp.now());
      when(mockExperience1.endDate).thenReturn(Timestamp.now());
      when(mockExperience1.logoURL)
          .thenReturn('http://example.com/mock_image1.jpg');
      when(mockExperience1.description).thenReturn('Mock Description1');

      mockExperience2 = MockExperience();
      when(mockExperience2.creationTimestamp).thenReturn(Timestamp.now());
      when(mockExperience2.peid).thenReturn('mockId2');
      when(mockExperience2.index).thenReturn(2);
      when(mockExperience2.jobTitle).thenReturn('Mock JobTitle2');
      when(mockExperience2.employmentType).thenReturn('Mock EmploymentType2');
      when(mockExperience2.companyName).thenReturn('Mock CompanyName2');
      when(mockExperience2.location).thenReturn('Mock Location2');
      when(mockExperience2.startDate).thenReturn(Timestamp.now());
      when(mockExperience2.endDate).thenReturn(Timestamp.now());
      when(mockExperience2.logoURL)
          .thenReturn('http://example.com/mock_image2.jpg');
      when(mockExperience2.description).thenReturn('Mock Description2');

      // Mock Experience 3
      mockExperience3 = MockExperience();
      when(mockExperience3.creationTimestamp).thenReturn(Timestamp.now());
      when(mockExperience3.peid).thenReturn('mockId3');
      when(mockExperience3.index).thenReturn(3);
      when(mockExperience3.jobTitle).thenReturn('Mock JobTitle3');
      when(mockExperience3.employmentType).thenReturn('Mock EmploymentType3');
      when(mockExperience3.companyName).thenReturn('Mock CompanyName3');
      when(mockExperience3.location).thenReturn('Mock Location3');
      when(mockExperience3.startDate).thenReturn(Timestamp.now());
      when(mockExperience3.endDate).thenReturn(Timestamp.now());
      when(mockExperience3.logoURL)
          .thenReturn('http://example.com/mock_image3.jpg');
      when(mockExperience3.description).thenReturn('Mock Description3');

      // Mock Experience 4
      mockExperience4 = MockExperience();
      when(mockExperience4.creationTimestamp).thenReturn(Timestamp.now());
      when(mockExperience4.peid).thenReturn('mockId4');
      when(mockExperience4.index).thenReturn(4);
      when(mockExperience4.jobTitle).thenReturn('Mock JobTitle4');
      when(mockExperience4.employmentType).thenReturn('Mock EmploymentType4');
      when(mockExperience4.companyName).thenReturn('Mock CompanyName4');
      when(mockExperience4.location).thenReturn('Mock Location4');
      when(mockExperience4.startDate).thenReturn(Timestamp.now());
      when(mockExperience4.endDate).thenReturn(Timestamp.now());
      when(mockExperience4.logoURL)
          .thenReturn('http://example.com/mock_image4.jpg');
      when(mockExperience4.description).thenReturn('Mock Description4');

      mockController = MockExperienceSectionController();
    });

    testWidgets('Experience Section shows expected data',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = ViewPagesTestConstants.experienceDesktopSize1;
      tester.view.devicePixelRatio = 1.0;
      // FlutterError.onError = ignoreOverflowErrors;
      final mockExperienceSectionData = [
        ExperienceDTO(
          jobTitle: mockExperience1.jobTitle,
          companyName: mockExperience1.companyName,
          location: mockExperience1.location,
          startDate: formatTimestamp(mockExperience1.startDate),
          endDate: formatEndDateTimestamp(mockExperience1.endDate),
          description: mockExperience1.description,
          logoURL: mockExperience1.logoURL,
          index: mockExperience1.index,
          employmentType: mockExperience1.employmentType,
        ),
        ExperienceDTO(
          jobTitle: mockExperience2.jobTitle,
          companyName: mockExperience2.companyName,
          location: mockExperience2.location,
          startDate: formatTimestamp(mockExperience2.startDate),
          endDate: formatEndDateTimestamp(mockExperience2.endDate),
          description: mockExperience2.description,
          logoURL: mockExperience2.logoURL,
          index: mockExperience2.index,
          employmentType: mockExperience2.employmentType,
        ),
        ExperienceDTO(
          jobTitle: mockExperience3.jobTitle,
          companyName: mockExperience3.companyName,
          location: mockExperience3.location,
          startDate: formatTimestamp(mockExperience3.startDate),
          endDate: formatEndDateTimestamp(mockExperience3.endDate),
          description: mockExperience3.description,
          logoURL: mockExperience3.logoURL,
          index: mockExperience3.index,
          employmentType: mockExperience3.employmentType,
        ),
        ExperienceDTO(
          jobTitle: mockExperience4.jobTitle,
          companyName: mockExperience4.companyName,
          location: mockExperience4.location,
          startDate: formatTimestamp(mockExperience4.startDate),
          endDate: formatEndDateTimestamp(mockExperience4.endDate),
          description: mockExperience4.description,
          logoURL: mockExperience4.logoURL,
          index: mockExperience4.index,
          employmentType: mockExperience4.employmentType,
        )
      ];

      when(mockController.getExperienceSectionData())
          .thenAnswer((_) => Future.value(mockExperienceSectionData));

      // Build the widget
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ExperienceSection(
              controller: mockController,
            ),
          ),
        );

        // Verify that the CircularProgressIndicator is displayed while loading
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for the widget to load data
        await tester.pump();

        // Verify that the CircularProgressIndicator is no longer displayed
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Verify that the title text is displayed
        expect(find.text('Professional\nExperience', findRichText: true),
            findsOneWidget);

        // Verify that ExperienceWidget widgets are displayed (check a few)
        expect(
            find.byType(ExperienceWidget),
            findsNWidgets(
                3)); // Assuming you want to display 3 experiences initially

        final Finder buttonToTap = find.byType(CustomViewMoreButton);
        await tester.ensureVisible(buttonToTap);
        await tester.pumpAndSettle();

        // Tap the "View More" button to show all experiences
        await tester.tap(buttonToTap);
        await tester.pump();

        // Verify that all ExperienceWidget widgets are displayed
        expect(find.byType(ExperienceWidget),
            findsNWidgets(mockExperienceSectionData.length));
      });
    });

    group("Experience Widget Tests", () {
      testWidgets('Experience Widget shows expected data',
          (WidgetTester tester) async {
        tester.view.physicalSize =
            ViewPagesTestConstants.experienceDesktopSize2;
        final mockExperienceWidgetData = ExperienceDTO(
          jobTitle: mockExperience1.jobTitle,
          companyName: mockExperience1.companyName,
          location: mockExperience1.location,
          startDate: formatTimestamp(mockExperience1.startDate),
          endDate: formatEndDateTimestamp(mockExperience1.endDate),
          description: mockExperience1.description,
          logoURL: mockExperience1.logoURL,
          index: mockExperience1.index,
          employmentType: mockExperience1.employmentType,
        );

        // Build the ExperienceWidget with the mock data
        await runWithNetworkImages(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: ExperienceWidget(experienceDTO: mockExperienceWidgetData),
            ),
          );

          // Use the `expect` function to make assertions
          // Example: Check if the job title is displayed correctly
          expect(find.text(mockExperience1.jobTitle as String), findsOneWidget);
          expect(
              find.text(
                  '${mockExperience1.companyName as String}, ${mockExperience1.location as String}'),
              findsOneWidget);

          expect(
              find.text(
                  '${formatTimestamp(mockExperience1.startDate)} - ${formatEndDateTimestamp(mockExperience1.endDate)}'),
              findsOneWidget);

          expect(find.text(mockExperience1.jobTitle as String), findsOneWidget);
          expect(find.text(mockExperience1.employmentType as String),
              findsOneWidget);
          expect(
              find.text(mockExperience1.description as String), findsOneWidget);

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
          final expectedImageUrl = mockExperienceWidgetData.logoURL;
          expect(image.image, isA<NetworkImage>());
          expect((image.image as NetworkImage).url, expectedImageUrl);
        });
      });
    });

    testWidgets('Experience Widget End Date is Present when Null',
        (WidgetTester tester) async {
      tester.view.physicalSize = ViewPagesTestConstants.experienceDesktopSize2;
      final mockExperienceWidgetData = ExperienceDTO(
        jobTitle: mockExperience1.jobTitle,
        companyName: mockExperience1.companyName,
        location: mockExperience1.location,
        startDate: formatTimestamp(mockExperience1.startDate),
        endDate: formatEndDateTimestamp(null),
        description: mockExperience1.description,
        logoURL: mockExperience1.logoURL,
        index: mockExperience1.index,
        employmentType: mockExperience1.employmentType,
      );

      // Build the ExperienceWidget with the mock data
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ExperienceWidget(experienceDTO: mockExperienceWidgetData),
          ),
        );

        expect(
            find.text(
                '${formatTimestamp(mockExperience1.startDate)} - Present'),
            findsOneWidget);
      });
    });
  });
}
