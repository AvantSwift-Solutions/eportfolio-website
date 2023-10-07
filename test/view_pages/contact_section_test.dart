import 'package:avantswift_portfolio/controllers/view_controllers/contact_section_controller.dart';
import 'package:avantswift_portfolio/dto/contact_section_dto.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/ui/custom_view_button.dart';
import 'package:avantswift_portfolio/view_pages/contact_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';

import 'mocks/award_cert_section_test.mocks.dart';
import 'mocks/contact_section_test.mocks.dart';

@GenerateMocks([User, ContactSectionController])
void main() {
  group('Contact Section Widget Test', () {
    late MockUser mockUser;
    late MockContactSectionController mockController; // Updated class name

    setUp(() {
      mockUser = MockUser();
      when(mockUser.name).thenReturn('Mock Name');
      when(mockUser.contactEmail).thenReturn('mock@example.com');
      when(mockUser.linkedinURL).thenReturn('http://example.com/mock_linked');
      mockController = MockContactSectionController();
    });

    testWidgets('AConact Section Section displays expected data on Desktop',
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

      // // Build your widget with the mock controller
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: ContactSection(
                controller: mockController,
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

        expect(find.text("Send"), findsOneWidget);
      });
    });
    testWidgets('AConact Section Section displays expected data on Mobile',
        (WidgetTester tester) async {
      // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
      tester.view.physicalSize = const Size(414, 896);
      tester.view.devicePixelRatio = 3.0;
      // // Create a mock controller to provide data for the test
      when(mockController.getContactSectionData()).thenAnswer((_) async =>
          ContactSectionDTO(
              name: mockUser.name,
              contactEmail: mockUser.contactEmail,
              linkedinURL: mockUser.linkedinURL));

      // // Build your widget with the mock controller
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: ContactSection(
                controller: mockController,
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

        expect(find.text("Send"), findsOneWidget);
      });
    });
  });
}
