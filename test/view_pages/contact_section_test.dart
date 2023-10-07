import 'package:avantswift_portfolio/controllers/view_controllers/contact_section_controller.dart';
import 'package:avantswift_portfolio/dto/contact_section_dto.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/ui/custom_view_button.dart';
import 'package:avantswift_portfolio/view_pages/contact_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';

import 'mocks/contact_section_test.mocks.dart';

@GenerateMocks([User, ContactSectionController])
void main() {
  group('Contact Section Widget Test', () {
    late MockUser mockUser;
    late MockContactSectionController mockController; // Updated class name
    late Map<String, String> mockFields;

    setUp(() {
      mockUser = MockUser();
      when(mockUser.name).thenReturn('Mock Name');
      when(mockUser.contactEmail).thenReturn('mock@example.com');
      when(mockUser.linkedinURL).thenReturn('http://example.com/mock_linked');

      mockFields = {
        'from_email': 'mockEnter@example.com',
        'from_name': "Mock Enter Email",
        'subject': 'Mock Enter Subject',
        'message': 'Mock Enter Message',
      };

      mockController = MockContactSectionController();
    });

    testWidgets('Contact Section Section displays expected data on Desktop',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      // // Create a mock controller to provide data for the test
      when(mockController.getContactSectionData()).thenAnswer((_) async =>
          ContactSectionDTO(
              name: mockUser.name,
              contactEmail: mockUser.contactEmail,
              linkedinURL: mockUser.linkedinURL));

      when(mockController.sendEmail(any, any))
          .thenAnswer((_) async => Future.value(true));

      // // Build your widget with the mock controller
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: ContactSection(
                  controller: mockController,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Let\'s Get in Touch'), findsOneWidget);
        expect(find.text('Send a Message'), findsOneWidget);
        expect(find.text('Connect Further'), findsOneWidget);

        expect(find.byType(TextFormField), findsNWidgets(4));

        expect(find.byType(CustomViewButton), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);

        expect(find.text("Send"), findsOneWidget);

        expect(find.text("Name"), findsOneWidget);
        expect(find.text("Email"), findsOneWidget);
        expect(find.text("Subject"), findsOneWidget);
        expect(find.text("Message"), findsOneWidget);
        expect(find.text("@${mockUser.name}"), findsOneWidget);

        expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));

        await tester.tap(find.text("Send"));

        await tester.pumpAndSettle();

        expect(find.text("Please enter your name"), findsOneWidget);
        expect(find.text("Please enter your email"), findsOneWidget);
        expect(find.text("Please enter a subject"), findsOneWidget);
        expect(find.text("Please enter a message"), findsOneWidget);

        // Test form fields
        List<TextField> formFields = List.empty(growable: true);
        Finder formFieldsFinder = find.byType(TextFormField);

        find.byType(TextField).evaluate().toList().forEach((element) {
          formFields.add(element.widget as TextField);
        });

        // find.byType(TextField).evaluate().toList().forEach((element) {
        //   formFields.add(element.widget as TextField);
        // });

        for (var element in formFields) {
          switch (element.decoration?.hintText) {
            case 'Name':
              await tester.enterText(
                  formFieldsFinder.first, mockFields["from_name"]!);
              break;

            case 'Email':
              await tester.enterText(
                  formFieldsFinder.at(1), mockFields["from_email"]!);
              break;

            case 'Subject':
              await tester.enterText(
                  formFieldsFinder.at(2), mockFields["subject"]!);

            case 'Message':
              await tester.enterText(
                  formFieldsFinder.last, mockFields["message"]!);
              break;
          }
        }

        await tester.pump();

        await tester.tap(find.text("Send"));

        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        verify(mockController.sendEmail(any, any))
            .called(1); // Verify that sendEmail was called
      });
    });
    testWidgets('Contact Section Section displays expected data on Mobile',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = const Size(408, 1500);
      tester.view.devicePixelRatio = 1.0;
      // // Create a mock controller to provide data for the test
      when(mockController.getContactSectionData()).thenAnswer((_) async =>
          ContactSectionDTO(
              name: mockUser.name,
              contactEmail: mockUser.contactEmail,
              linkedinURL: mockUser.linkedinURL));

      when(mockController.sendEmail(any, any))
          .thenAnswer((_) async => Future.value(true));

      // // Build your widget with the mock controller
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Material(
                child: ContactSection(
                  controller: mockController,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Let\'s Get in Touch'), findsOneWidget);
        expect(find.text('Send a Message'), findsOneWidget);
        expect(find.text('Connect Further'), findsOneWidget);

        expect(find.byType(TextFormField), findsNWidgets(4));

        expect(find.byType(CustomViewButton), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);

        expect(find.text("Send"), findsOneWidget);

        expect(find.text("Name"), findsOneWidget);
        expect(find.text("Email"), findsOneWidget);
        expect(find.text("Subject"), findsOneWidget);
        expect(find.text("Message"), findsOneWidget);
        expect(find.text("@${mockUser.name}"), findsOneWidget);

        expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));

        await tester.tap(find.text("Send"));

        await tester.pumpAndSettle();

        expect(find.text("Please enter your name"), findsOneWidget);
        expect(find.text("Please enter your email"), findsOneWidget);
        expect(find.text("Please enter a subject"), findsOneWidget);
        expect(find.text("Please enter a message"), findsOneWidget);

        // Test form fields
        List<TextField> formFields = List.empty(growable: true);
        Finder formFieldsFinder = find.byType(TextFormField);

        find.byType(TextField).evaluate().toList().forEach((element) {
          formFields.add(element.widget as TextField);
        });

        // find.byType(TextField).evaluate().toList().forEach((element) {
        //   formFields.add(element.widget as TextField);
        // });

        for (var element in formFields) {
          switch (element.decoration?.hintText) {
            case 'Name':
              await tester.enterText(
                  formFieldsFinder.first, mockFields["from_name"]!);
              break;

            case 'Email':
              await tester.enterText(
                  formFieldsFinder.at(1), mockFields["from_email"]!);
              break;

            case 'Subject':
              await tester.enterText(
                  formFieldsFinder.at(2), mockFields["subject"]!);

            case 'Message':
              await tester.enterText(
                  formFieldsFinder.last, mockFields["message"]!);
              break;
          }
        }

        await tester.pump();

        await tester.tap(find.text("Send"));

        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        verify(mockController.sendEmail(any, any))
            .called(1); // Verify that sendEmail was called
      });
    });
  });
}
