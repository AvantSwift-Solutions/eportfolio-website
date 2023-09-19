import 'package:avantswift_portfolio/dto/experience_dto.dart';
import 'package:avantswift_portfolio/view_pages/experience_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // testWidgets('ExperienceSection widget test', (WidgetTester tester) async {
  //   // Build our widget
  //   await tester.pumpWidget(const ExperienceSection());

  //   // Verify that CircularProgressIndicator is displayed initially
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);

  //   // Simulate the FutureBuilder completing with data
  //   // Replace with your test data as needed
  //   await tester.pump();

  //   // final titleFinder = find.text('Professional\n');
  //   final messageFinder = find.text('Experience');

  //   // Verify that the data is displayed
  //   // expect(titleFinder, find);
  //   expect(messageFinder, findsOneWidget);

  //   // Tap the "Show All" button
  //   await tester.tap(find.text('Show All'));
  //   await tester.pump();

  //   // Verify that "Show Less" button appears after tapping
  //   expect(find.text('Show Less'), findsOneWidget);

  //   // Add more test scenarios as needed
  // });

  // testWidgets('ExperienceWidget widget test', (WidgetTester tester) async {
  // ExperienceDTO experienceDTO = ExperienceDTO(
  //     jobTitle: 'Example Job Title',
  //     companyName: 'Example Company',
  //     location: 'Location',
  //     description: "example description",
  //     endDate: "Example End",
  //     startDate: "Example Start",
  //     index: 0);

  //   // Build our widget
  //   await tester.pumpWidget(ExperienceWidget(
  //     experienceDTO: experienceDTO,
  //   ));

  //   // Verify that CircularProgressIndicator is displayed initially
  //   // expect(find.byType(CircularProgressIndicator), findsOneWidget);

  //   // Simulate the FutureBuilder completing with data
  //   // Replace with your test data as needed
  //   await tester.pump();

  //   // Verify that the data is displayed
  //   expect(find.text('Example Company'), findsOneWidget);
  //   expect(find.text('Example Job Title'), findsOneWidget);

  //   // Add more test scenarios as needed
  // });
  testWidgets('ExperienceWidget should render correctly',
      (WidgetTester tester) async {
    // Create a mock instance of your DTO class.
    final experienceDTO = ExperienceDTO(
        // Initialize properties with test data here.
        // For example:
        jobTitle: 'Example Job Title',
        companyName: 'Example Company',
        location: 'Example Location',
        description: "example description",
        endDate: "Example End",
        startDate: "Example Start",
        index: 0
        // Add other properties as needed.
        );

    // Build the widget with the given experienceDTO.
    await tester.pumpWidget(
      MaterialApp(
        home: ExperienceWidget(experienceDTO: experienceDTO),
      ),
    );

    // Add widget test expectations here to verify the rendering.
    // For example, you can check if specific Text widgets are displayed.
    expect(find.text('Example Company, Example Location'), findsOneWidget);
    // Add more expectations as needed.

    // You can also use `.evaluate()` to access the widget's properties
    // and make assertions on them if necessary.
    final widget =
        tester.widget<ExperienceWidget>(find.byType(ExperienceWidget));
    expect(widget.experienceDTO.companyName, 'Example Company');
    expect(widget.experienceDTO.location, 'Example Location');
  });
}

// import 'package:avantswift_portfolio/controllers/admin_controllers/contact_section_admin_controller.dart';
// import 'package:avantswift_portfolio/controllers/admin_controllers/experience_section_admin_controller.dart';
// import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';
// import 'package:avantswift_portfolio/view_pages/experience_section.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

// class MockExperienceRepoService extends Mock implements ExperienceRepoService {}

// void main() {
//   testWidgets('ExperienceSection should render correctly',
//       (WidgetTester tester) async {
//     // Create a mock instance of ExperienceRepoService.
//     final mockRepoService = MockExperienceRepoService();
//     ExperienceSectionAdminController controller =
//         ExperienceSectionAdminController(mockRepoService);

//     // Define mock data that your FutureBuilder will return.
//     // Replace this with your actual mock data for testing.
//     final mockData =
//         controller.getExperienceSectionData(); // Replace with your mock data.

//     // Mock the behavior of getExperienceSectionData() to return your mock data.
//     when(mockRepoService.getAllExperiences()).thenAnswer((_) async => mockData);

//     // Build the ExperienceSection widget within a test environment.
//     await tester.pumpWidget(
//       MaterialApp(
//         home: ExperienceSection(),
//       ),
//     );

//     // Wait for the FutureBuilder to complete and rebuild the widget.
//     await tester.pump();

//     // Use the `expect` function to assert that the widget renders as expected.
//     expect(find.text('Professional'),
//         findsOneWidget); // Replace with your expected widget texts.

//     // Add more assertions as needed to verify the widget's behavior.
//   });
// }
